Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7624B286425;
	Thu,  4 Dec 2025 21:53:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764885198; cv=none; b=jdUUT3A8chUEKqZNfO4d7xuKv5MHrM+LoxUpnziWl5qd0vU9nL/j40dUx69qkm4PPjWUmN67v4pYPKLNZBFsiqO/W4Mh2BglmiBbAxjgNZTnXzbcevzFCH9dnGp7aD0l3CLCymLbBC3vWaKFu90QS1cIOLmg5FeZFrdi7wz22gE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764885198; c=relaxed/simple;
	bh=kg2NAn4mOFURo7SajQPqrSi1sT8r5s8WVsIX49socv0=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=jh+Q7Xa4Jhptbm2v6sCIWbabjmMybx1i0BFmI1A3Tyxc2Ii4V9wbO0Zh/ZI0HVVDAc7kfYxhXm1quM9z7/NletGtwIQzs/mieFB/Y1YJlYnJdVvRIHEGA1Cju2VIwS43XNL/SlLfn5r0uSMzv4OMLC3DYlpbjPdhVtsonhGSYM4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=dXIb5esR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="dXIb5esR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 066D1C113D0;
	Thu,  4 Dec 2025 21:53:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1764885198;
	bh=kg2NAn4mOFURo7SajQPqrSi1sT8r5s8WVsIX49socv0=;
	h=Date:From:To:Cc:Subject:From;
	b=dXIb5esRCWmZObmwJEhzVCazmCjnzfRSJUvOuwieqKvf8VrGkSG5EBRWPx8QlXLel
	 pMNacNXAamaYsNpxBE//VaeIZOWzRE+LwwaMFOpebriYKFNqfqnx2Ymvn5SCA5yymS
	 cq7M9nFuWTfGjq+AKFA3d3k8otgah/nJJgRwRuKOu0fvq7z2w4e5bo5TesyK57VlmX
	 lsrbMGS4p9n6wlfWMQLKjF7CPJDYZQnpsY6p7Ee8IybtB+ev/x5AGkgoQv/5Nd8UkR
	 k5AregvAsCNP2SzaT7vOXRUeGbr8qG4fzlku/llJi/GJPFtIa4HKPAOL1CPFELOUdC
	 dUhoJ7gD6D2rA==
Date: Thu, 4 Dec 2025 13:53:17 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Zorro Lang <zlang@redhat.com>
Cc: fstests <fstests@vger.kernel.org>, xfs <linux-xfs@vger.kernel.org>
Subject: [PATCH] fsstress: allow multiple suboptions to -f
Message-ID: <20251204215317.GE89454@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

From: Darrick J. Wong <djwong@kernel.org>

I got bitten by fsstress's argument parsing recently because it turns
out that if you do:

# fsstress -z -f creat=2,unlink=1

It will ignore everything after the '2' and worse yet it won't tell you
that it's done so unless you happen to pass -S to make it spit out the
frequency table.

Adapt process_freq to tokenize the argument string so that it can handle
a comma-separated list of key-value arguments.

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
---
 ltp/fsstress.c |   43 +++++++++++++++++++++++++++++--------------
 1 file changed, 29 insertions(+), 14 deletions(-)

diff --git a/ltp/fsstress.c b/ltp/fsstress.c
index 00773cc004bfac..c17ac440414325 100644
--- a/ltp/fsstress.c
+++ b/ltp/fsstress.c
@@ -1792,23 +1792,38 @@ opendir_path(pathname_t *name)
 void
 process_freq(char *arg)
 {
-	opdesc_t	*p;
-	char		*s;
+	char		*token;
+	char		*argstr = strdup(arg);
+	char		*tokstr = argstr ? argstr : arg;
 
-	s = strchr(arg, '=');
-	if (s == NULL) {
-		fprintf(stderr, "bad argument '%s'\n", arg);
-		exit(1);
-	}
-	*s++ = '\0';
-	for (p = ops; p < ops_end; p++) {
-		if (strcmp(arg, p->name) == 0) {
-			p->freq = atoi(s);
-			return;
+	while ((token = strtok(tokstr, ",")) != NULL) {
+		opdesc_t	*p = ops;
+		char		*s = strchr(token, '=');
+		int		found = 0;
+
+		if (!s) {
+			fprintf(stderr, "bad argument '%s'\n", token);
+			exit(1);
+		}
+
+		*s = '\0';
+		for (; p < ops_end; p++) {
+			if (strcmp(token, p->name) == 0) {
+				p->freq = atoi(s + 1);
+				found = 1;
+				break;
+			}
 		}
+
+		if (!found) {
+			fprintf(stderr, "can't find op type %s for -f\n", token);
+			exit(1);
+		}
+
+		tokstr = NULL;
 	}
-	fprintf(stderr, "can't find op type %s for -f\n", arg);
-	exit(1);
+
+	free(argstr);
 }
 
 int
