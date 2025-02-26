Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0109A2222A1
	for <linux-xfs@vger.kernel.org>; Wed, 26 Feb 2025 14:50:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740581459; cv=none; b=R+gyLy7vD6gDbxaBpp1Wy5cFxFjazjuR/OT8K0dVJOsPDaldbmH2wAp/HPJuyH68f/Prb2sKPRcr5Nx352GkUj+KiiJm62ByQRMVbRld8LjWzGsjpAQQ3qdKZWQDUNDywKyEhWrhLobrw1u4ZHKqiDP1bX2idLbhYGJKRAucbBo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740581459; c=relaxed/simple;
	bh=tcBXIs0YL5aKKCC18HjtEyX22AtuwMFsrtdVirpJIAI=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=pQLjeCEXx0Xw2HWFapU6Hju00ciUY6PyXaqdHzr8v2O7Ax1OkVZOdsAcS/5zsyqCoHlgoBw7LTWNuvbikMH4C8Um5vXJArG+T6CMK3Bdhhj3T73Pges0YluHX5vB0ars1FuouAXDH9TAjdA2vUQLMZPb1oYkGxZL4O0sjgT9b1Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=ftgvar9C; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="ftgvar9C"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1740581457;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=VPCMimwk8BJggPriOZYINqGW555s3k20gz7o97Ni02E=;
	b=ftgvar9C0Ja+btq5wYC8514SZByg4+YXCFwtOsCWH7HDYYFmmAMIlsLFowRMxInFCi7aAI
	iDVbidAWpW/3WBJ8bVw4yxG3eWVQ+UkW4zYmpxrcgLQpFjIl62ulCdA+uL7GHiVWm5wLtM
	Ziocia2dBWXoBmNIaIPuC92Q/syMRYI=
Received: from mail-ej1-f70.google.com (mail-ej1-f70.google.com
 [209.85.218.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-303-Ns2ItG7wMLCeLV28dOfcyw-1; Wed, 26 Feb 2025 09:50:55 -0500
X-MC-Unique: Ns2ItG7wMLCeLV28dOfcyw-1
X-Mimecast-MFC-AGG-ID: Ns2ItG7wMLCeLV28dOfcyw_1740581455
Received: by mail-ej1-f70.google.com with SMTP id a640c23a62f3a-abba896add9so667693166b.1
        for <linux-xfs@vger.kernel.org>; Wed, 26 Feb 2025 06:50:55 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1740581454; x=1741186254;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=VPCMimwk8BJggPriOZYINqGW555s3k20gz7o97Ni02E=;
        b=vYfYGaF9uEXwOZIjVMKCioGs98ajsACPcZtNZLUYig4IHV0OujppaRrPH8kn5tDMiN
         /+/pwyukaUArDYytEpCqfLE21N92M1VUt9QeqpAYnymjj5cc8Nwr0pm7i0d2RP0qUoCa
         Kf9eryEn30hKuuym0rrAVjP4kxKGKPVXTV+Hi3Tt5BamTCnGZl+NUS1txYQ9+R28Devp
         w4KNc/MeHRntopi18IBJ28ZrYrXuIyAJnN0cXdAawshYYa6EKkXSE8Qs1eLIdhQO9z7Q
         IJtoVFKHK3j39RjiaJ+wHar9+mxtBZExH6aJcc5whD3dPS7w5L5RTssby5NhtVV3KAa9
         ZNmA==
X-Gm-Message-State: AOJu0YwoPzE3NWcx9bADnpei1zHJNszTIHan0s7Y4A5lC4UwaB5LLIM2
	dvi0pdBcMAhwZZNykpMl+2SRw2KNc/NOh2PGVAeQROYfjD1qUUwNCsZOxOBxY5YcDZOQ8S8qyJ+
	x+bLpDhuk8+REMb2XtenJkAMJVotwlTcAQ/LK4jNA+0y2pLscrJzPwewTCINTvFNR
X-Gm-Gg: ASbGnctmFvyW6jb/BQavf1d3JmZTWvfn+d3ziFrz6dj4t3FrZHXxSTXbd8isBUVNM+s
	KxShDYCpgCEG7YnIix6mOiIWJSEMnB3T2oxs6r/o4WmGG6DvhAaSvi0LivMrp/yBJd6guD9s5KT
	5oBnecgcBsb5h9kWd2n7pLxMSbqKfpyyRpvyazFrFGsVs878y5Usipk45qMGrwG5w/dVijC05PS
	09GNr/etenpJhvEoPk3E0X44UDMK1QOItBU/mUcpjJkKXUJOBFRJ2c2QxqiGOAw09voOXnqNYKb
	V3SUKqCanX0du0OFsLcvsHfIEL+2UwCHn0VT/PPHlw==
X-Received: by 2002:a17:906:80e:b0:abc:c34:4134 with SMTP id a640c23a62f3a-abc0c344449mr1842448966b.18.1740581454116;
        Wed, 26 Feb 2025 06:50:54 -0800 (PST)
X-Google-Smtp-Source: AGHT+IGJVNJC7BRPjjRdNaLZa8fRTNmOoQg3O6NpqwAn7UB8GSGoZLr4NqAjH4VpXLqJvxQbg/4pgA==
X-Received: by 2002:a17:906:80e:b0:abc:c34:4134 with SMTP id a640c23a62f3a-abc0c344449mr1842446566b.18.1740581453742;
        Wed, 26 Feb 2025 06:50:53 -0800 (PST)
Received: from [127.0.0.2] (ip-217-030-074-039.aim-net.cz. [217.30.74.39])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-abed1cd564esm337731666b.21.2025.02.26.06.50.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 26 Feb 2025 06:50:53 -0800 (PST)
From: Andrey Albershteyn <aalbersh@redhat.com>
X-Google-Original-From: Andrey Albershteyn <aalbersh@kernel.org>
Date: Wed, 26 Feb 2025 15:50:33 +0100
Subject: [PATCH v5 08/10] release.sh: add -f to generate for-next update
 email
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20250226-update-release-v5-8-481914e40c36@kernel.org>
References: <20250226-update-release-v5-0-481914e40c36@kernel.org>
In-Reply-To: <20250226-update-release-v5-0-481914e40c36@kernel.org>
To: linux-xfs@vger.kernel.org
Cc: "Darrick J. Wong" <djwong@kernel.org>, 
 Andrey Albershteyn <aalbersh@kernel.org>
X-Mailer: b4 0.14.2
X-Developer-Signature: v=1; a=openpgp-sha256; l=1520; i=aalbersh@kernel.org;
 h=from:subject:message-id; bh=tcBXIs0YL5aKKCC18HjtEyX22AtuwMFsrtdVirpJIAI=;
 b=owJ4nJvAy8zAJea2/JXEGuOHHIyn1ZIY0vdrOZ+qEnycxVGgoB87ie3htr+JN7jKkh/PfxR4Q
 itlZfdup6MdpSwMYlwMsmKKLOuktaYmFUnlHzGokYeZw8oEMoSBi1MAJvIyi+G/X1l7mZvtJe0j
 7c8S52z+kSfto6P+8mRKs8imZfaPFTrnMvz3vB+37EfSc9b+3/1zIqb+DxdsrZaZVmUveOvNzwv
 2S+XZAIiwShU=
X-Developer-Key: i=aalbersh@kernel.org; a=openpgp;
 fpr=AE1B2A9562721A6FC4307C1F46A7EA18AC33E108

Add --for-next/-f to generate ANNOUNCE email for for-next branch
update. This doesn't require new commit/tarball/tags, so skip it.

Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Andrey Albershteyn <aalbersh@kernel.org>
---
 release.sh | 16 ++++++++++++++++
 1 file changed, 16 insertions(+)

diff --git a/release.sh b/release.sh
index 1c0c767863d6fe6572315ba26b58f66f8668a93c..32084fb9fd904cf308135f842a20a5f9e8a99615 100755
--- a/release.sh
+++ b/release.sh
@@ -14,12 +14,14 @@ set -e
 KUP=0
 COMMIT=1
 LAST_HEAD=""
+FOR_NEXT=0
 
 help() {
 	echo "$(basename $0) - prepare xfsprogs release tarball or for-next update"
 	printf "\t[--kup|-k] upload final tarball with KUP\n"
 	printf "\t[--no-commit|-n] don't create release commit\n"
 	printf "\t[--last-head|-l] commit of the last release\n"
+	printf "\t[--for-next|-f] generate announce email for for-next update\n"
 }
 
 update_version() {
@@ -96,6 +98,9 @@ while [ $# -gt 0 ]; do
 			LAST_HEAD=$2
 			shift
 			;;
+		--for-next|-f)
+			FOR_NEXT=1
+			;;
 		--help|-h)
 			help
 			exit 0
@@ -108,6 +113,17 @@ while [ $# -gt 0 ]; do
 	shift
 done
 
+if [ $FOR_NEXT -eq 1 ]; then
+	echo "Push your for-next branch:"
+	printf "\tgit push origin for-next:for-next\n"
+	prepare_mail "for-next"
+	if [ -n "$LAST_HEAD" ]; then
+		echo "Command to send ANNOUNCE email"
+		printf "\tneomutt -H $mail_file\n"
+	fi
+	exit 0
+fi
+
 if [ -z "$EDITOR" ]; then
 	EDITOR=$(command -v vi)
 fi

-- 
2.47.2

