Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 50731223329
	for <linux-xfs@vger.kernel.org>; Wed, 26 Feb 2025 14:50:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740581458; cv=none; b=fit+E1ouP/mXiRWASL6dCU5fpX+J1wZ0wqf5Odd1a5bJKuAxJk1XkNFbcdSJIG3rhWTryFr8kpm8yGY2IGQ613X9Wv31H0bh8PUXeJPMYAqxkawhxEX/pLK2z51QArRTAdYmspoWI18MqQMt83iGWH+i+lkrAdmjaoO6IQw10UI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740581458; c=relaxed/simple;
	bh=6O0S7TWkHSEtg09ESsQ6vxXaH4L57S+mQLcdc4N9Y0E=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=s0/kjNKeiBRYR+EQZJdk+FxFGm09Efhgh2NfPobm13OwtsWXahOyAovK6sxbdikQHt42nzCxDISWhYLQI4QPuAHR7ZPlScdmr9l6wU+jUGvZW1rBgm8yZi+8kpNCyxJ2AACVDb8U9mlrowEQ9YfSDffRYiO0gkMTh3Bkcj+Vifs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Rp0tOoWA; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Rp0tOoWA"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1740581456;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=gxR62M3Qycv1E9pVPUB0zdr4XAEKWfS7eyOmlP2oXC4=;
	b=Rp0tOoWAlPn8gG6QAcZN2IQqYr06F2Jn2tTUeNpEIcibgc8/nEBIBOmvRAKgsz33NsGU0S
	hwAyZ6loM1KsA9KzdfzHZ8E+7VFlFPI6RqeB1zbDPZt7dX7FPcbuZlUpo4JzgqQ6ia99Hu
	9v69UyDo2WRQEFh7X7dq8KvAznqlHTc=
Received: from mail-ej1-f70.google.com (mail-ej1-f70.google.com
 [209.85.218.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-608-Kr9edyIiOK-WHairzSVyvQ-1; Wed, 26 Feb 2025 09:50:54 -0500
X-MC-Unique: Kr9edyIiOK-WHairzSVyvQ-1
X-Mimecast-MFC-AGG-ID: Kr9edyIiOK-WHairzSVyvQ_1740581454
Received: by mail-ej1-f70.google.com with SMTP id a640c23a62f3a-abbba16956bso987315266b.2
        for <linux-xfs@vger.kernel.org>; Wed, 26 Feb 2025 06:50:54 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1740581453; x=1741186253;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=gxR62M3Qycv1E9pVPUB0zdr4XAEKWfS7eyOmlP2oXC4=;
        b=Mhijcmh1TfPfYySgj2j505WzNqStGgjN5vH7RfiIM6iBH96dL3L8iMR1wUq3vuZlwK
         6bPU5pJsonzw9ueJ/NfuTFVufUuagr5b9AbZb6wtrEaqcdv53Kx1wLL6A0UuAfTGNND/
         +HwYfvy5Wvasrx7X+3NTiDFMZBpJrIR7iqBBTV3iA4KbjxRI8FiHECo3UtgUGLHMt7eZ
         WajKQJlOBq6pry3PtiVlP3a+4SAklp5xKHmD7oEZqyduR+346rKYhSXD3KPfm1N7XNXM
         J07LQnv3waaov/FzBDeJMjwj5xN18x0/5KRbZD5inGzzAHkdBvXBnosFoXaTV5oh4wVu
         0LFA==
X-Gm-Message-State: AOJu0Yx1NroSvAtWdegNdxPvbtuT16Xc9srgQvftE8SQmx6c4kVsMC0Z
	+3OogkEqmFuT67DATz5Id3mW2qS78V3Sd9tdvhO1zhGsD16PldS7DUHcxADNzj3VZkQXilE3WV0
	IQBEbobDQVS1iLAcMQsgo/CRHll8e65Vr9XhgDIlgEiGk51lHMlULRvXH
X-Gm-Gg: ASbGncvB/aQpbp/mffFiGolXMWWW4fZLCd2w6vso0HNnceqG8N+/C4d/mWMKLdJlSNG
	AoIBWJhSMtOVHKoUNPoIMBcZFF4joRqSOKcXKHLfxbU1ZLDlz5cmwlIn3IPkhN3VPyPYrYuu79l
	hksXIDjf7Y53liOStscXfj4dFfwDKOxg+IiqLHsKK1IIwSEhgUa7uT7mRFk1k+eXozrB9TjooyL
	IqLPEeYkGilDrrn5JPxBielYHVF8Hq8QOC8LQ09LLCmMMAAgMnNu0Z7Su7ZLMTGa0p4YwioDK8t
	iD+kEm+YdEG5JGV1tPJxci9qaODHk20pyqW1xo535Q==
X-Received: by 2002:a17:907:7f90:b0:ab7:bc17:b3a4 with SMTP id a640c23a62f3a-abed0e098a3mr1080763966b.34.1740581453542;
        Wed, 26 Feb 2025 06:50:53 -0800 (PST)
X-Google-Smtp-Source: AGHT+IGKJy8zmUFXlBn83Yjn1DIxH0zDl6L7+jDSw/6TW2uA+uck0JNKLyBk0NU0k+wQIhC8ojUt2g==
X-Received: by 2002:a17:907:7f90:b0:ab7:bc17:b3a4 with SMTP id a640c23a62f3a-abed0e098a3mr1080759566b.34.1740581453089;
        Wed, 26 Feb 2025 06:50:53 -0800 (PST)
Received: from [127.0.0.2] (ip-217-030-074-039.aim-net.cz. [217.30.74.39])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-abed1cd564esm337731666b.21.2025.02.26.06.50.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 26 Feb 2025 06:50:52 -0800 (PST)
From: Andrey Albershteyn <aalbersh@redhat.com>
X-Google-Original-From: Andrey Albershteyn <aalbersh@kernel.org>
Date: Wed, 26 Feb 2025 15:50:32 +0100
Subject: [PATCH v5 07/10] release.sh: generate ANNOUNCE email
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20250226-update-release-v5-7-481914e40c36@kernel.org>
References: <20250226-update-release-v5-0-481914e40c36@kernel.org>
In-Reply-To: <20250226-update-release-v5-0-481914e40c36@kernel.org>
To: linux-xfs@vger.kernel.org
Cc: "Darrick J. Wong" <djwong@kernel.org>, 
 Andrey Albershteyn <aalbersh@kernel.org>
X-Mailer: b4 0.14.2
X-Developer-Signature: v=1; a=openpgp-sha256; l=2633; i=aalbersh@kernel.org;
 h=from:subject:message-id; bh=6O0S7TWkHSEtg09ESsQ6vxXaH4L57S+mQLcdc4N9Y0E=;
 b=owJ4nJvAy8zAJea2/JXEGuOHHIyn1ZIY0vdrOWeZhiocWazDfNSguqrk7XmHfqdVh76JVXxy2
 cZhJ8ClxtFRysIgxsUgK6bIsk5aa2pSkVT+EYMaeZg5rEwgQxi4OAVgIrt7GBn27T9iF2P/Xnun
 A29Pe4WW/tOUVB7H/9nyc/46vnkS2vORkeGyhOSSVNOeCmvnKSZT/1xbrjJ/Udh/u9ffLl5eq7i
 laj4vAK/JRdw=
X-Developer-Key: i=aalbersh@kernel.org; a=openpgp;
 fpr=AE1B2A9562721A6FC4307C1F46A7EA18AC33E108

Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Andrey Albershteyn <aalbersh@kernel.org>
---
 release.sh | 54 ++++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 54 insertions(+)

diff --git a/release.sh b/release.sh
index 385607f636d965ad98f0f3115e6f34d9e4042592..1c0c767863d6fe6572315ba26b58f66f8668a93c 100755
--- a/release.sh
+++ b/release.sh
@@ -13,11 +13,13 @@ set -e
 
 KUP=0
 COMMIT=1
+LAST_HEAD=""
 
 help() {
 	echo "$(basename $0) - prepare xfsprogs release tarball or for-next update"
 	printf "\t[--kup|-k] upload final tarball with KUP\n"
 	printf "\t[--no-commit|-n] don't create release commit\n"
+	printf "\t[--last-head|-l] commit of the last release\n"
 }
 
 update_version() {
@@ -40,6 +42,48 @@ update_version() {
 	sed -i "1s/^/xfsprogs (${version}-1) unstable; urgency=low\n/" ./debian/changelog
 }
 
+prepare_mail() {
+	branch="$1"
+	mail_file=$(mktemp)
+	if [ -n "$LAST_HEAD" ]; then
+		if [ $branch == "master" ]; then
+			reason="$(git describe --abbrev=0 $branch) released"
+		else
+			reason="for-next updated to $(git log --oneline --format="%h" -1 $branch)"
+		fi;
+		cat << EOF > $mail_file
+To: linux-xfs@vger.kernel.org
+Cc: $(./tools/git-contributors.py $LAST_HEAD..$branch --separator ', ')
+Subject: [ANNOUNCE] xfsprogs: $reason
+
+Hi folks,
+
+The xfsprogs $branch branch in repository at:
+
+	git://git.kernel.org/pub/scm/fs/xfs/xfsprogs-dev.git
+
+has just been updated.
+
+Patches often get missed, so if your outstanding patches are properly reviewed
+on the list and not included in this update, please let me know.
+
+The for-next branch has also been updated to match the state of master.
+
+The new head of the $branch branch is commit:
+
+$(git log --oneline --format="%H" -1 $branch)
+
+New commits:
+
+$(git shortlog --format="[%h] %s" $LAST_HEAD..$branch)
+
+Code Diffstat:
+
+$(git diff --stat --summary -C -M $LAST_HEAD..$branch)
+EOF
+	fi
+}
+
 while [ $# -gt 0 ]; do
 	case "$1" in
 		--kup|-k)
@@ -48,6 +92,10 @@ while [ $# -gt 0 ]; do
 		--no-commit|-n)
 			COMMIT=0
 			;;
+		--last-head|-l)
+			LAST_HEAD=$2
+			shift
+			;;
 		--help|-h)
 			help
 			exit 0
@@ -126,6 +174,12 @@ if [ $KUP -eq 1 ]; then
 		pub/linux/utils/fs/xfs/xfsprogs/
 fi;
 
+prepare_mail "master"
+
 echo ""
 echo "Done. Please remember to push out tags and the branch."
 printf "\tgit push origin v${version} master:master master:for-next\n"
+if [ -n "$LAST_HEAD" ]; then
+	echo "Command to send ANNOUNCE email"
+	printf "\tneomutt -H $mail_file\n"
+fi

-- 
2.47.2

