Received: from buxtehude.debian.org (buxtehude.debian.org [209.87.16.39])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 54FB231770B
	for <linux-xfs@vger.kernel.org>; Wed, 15 Oct 2025 09:31:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.87.16.39
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760520664; cv=none; b=QNt8dHTn1mBaE2Z4RZ7A4O1C7BUONvikYRcE8vXZN7+rC769sRryuhQOBcS0oYkS49aAc545vjH969jyrMwilyotgHVpJPvARg1tP1hmPXzBxzFSiSgVSA9uxMQg7J+qFs+zVcaH5dtwKhQNl+Ygu+ysj36TP9i3O0MFHc8TK/o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760520664; c=relaxed/simple;
	bh=E9mpLsKPkCHC04KA8uliEqAwT6K2uu6XdMY4O7nzGy0=;
	h=Subject:References:Date:From:To:Cc:Message-ID:MIME-Version:
	 In-Reply-To:Content-Type:Content-Disposition; b=qe8cxOUt/c81TVWpPib11IysX1ynKIH9W4iueiZ+oqL4n9QuW8qIeMRiMZ2LuJQzk6txWMcSXBzwTMXtdTxr+nrvPTZyPVxALeSMSgb4/kAIe2Davi9P49+6n5aHsWwJsIdkzhZip/F97SpwyNPKRPayI5oyDjJlNFONlez9qiQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=redhat.com; spf=none smtp.mailfrom=buxtehude.debian.org; dkim=fail (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=WVfTeOxq reason="signature verification failed"; arc=none smtp.client-ip=209.87.16.39
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=buxtehude.debian.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="WVfTeOxq"
Received: from debbugs by buxtehude.debian.org with local (Exim 4.96)
	(envelope-from <debbugs@buxtehude.debian.org>)
	id 1v8xqX-000Kln-30;
	Wed, 15 Oct 2025 09:31:01 +0000
X-Loop: owner@bugs.debian.org
Subject: Bug#1116595: [PATCH] xfs_scrub_fail: reduce security lockdowns to avoid postfix problems
Reply-To: Andrey Albershteyn <aalbersh@redhat.com>, 1116595@bugs.debian.org
Resent-From: Andrey Albershteyn <aalbersh@redhat.com>
Resent-To: debian-bugs-dist@lists.debian.org
Resent-CC: linux-xfs@vger.kernel.org
X-Loop: owner@bugs.debian.org
Resent-Date: Wed, 15 Oct 2025 09:31:01 +0000
Resent-Message-ID: <handler.1116595.B1116595.176052056979183@bugs.debian.org>
X-Debian-PR-Message: followup 1116595
X-Debian-PR-Package: xfsprogs
X-Debian-PR-Keywords: 
References: <aNmt9M4e9Q6wqwxH@teal.hq.k1024.org> <20251013233424.GT6188@frogsfrogsfrogs> <aNmt9M4e9Q6wqwxH@teal.hq.k1024.org>
X-Debian-PR-Source: xfsprogs
Received: via spool by 1116595-submit@bugs.debian.org id=B1116595.176052056979183
          (code B ref 1116595); Wed, 15 Oct 2025 09:31:01 +0000
Received: (at 1116595) by bugs.debian.org; 15 Oct 2025 09:29:29 +0000
X-Spam-Level: 
X-Spam-Bayes: score:0.0000 Tokens: new, 46; hammy, 150; neutral, 255; spammy,
	0. spammytokens: hammytokens:0.000-+--Signed-off-by,
	0.000-+--Signedoffby, 0.000-+--journalctl, 0.000-+--UD:slice,
	0.000-+--reviewed-by
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:59227)
	by buxtehude.debian.org with esmtp (Exim 4.96)
	(envelope-from <aalbersh@redhat.com>)
	id 1v8xp2-000Kay-3C
	for 1116595@bugs.debian.org;
	Wed, 15 Oct 2025 09:29:29 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1760520567;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=88GBGQzfIph4xnxrzgsJBHr0+JpWKkaGoeYMZcyTe1c=;
	b=WVfTeOxqUUCVwpnBm9ztY7KBiEcT2wNEI9n8q1UDPdhcUlqk0YjyR/2ZH15MVAnmW3DADu
	lQCunt0Dce5v3mEJGCxuSBqQO2XY3pFK6TQtpGk7DYZqW2VT8uezDggywGfnBTVT63IM16
	JbgFvgkTM2AMUshxz/K/6KuvhzBMqvo=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-642-nGmG2pc1OdmXfxC7nApl9w-1; Wed, 15 Oct 2025 05:23:17 -0400
X-MC-Unique: nGmG2pc1OdmXfxC7nApl9w-1
X-Mimecast-MFC-AGG-ID: nGmG2pc1OdmXfxC7nApl9w_1760520196
Received: by mail-wm1-f72.google.com with SMTP id 5b1f17b1804b1-470fd59d325so4147505e9.0
        for <1116595@bugs.debian.org>; Wed, 15 Oct 2025 02:23:16 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760520196; x=1761124996;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=88GBGQzfIph4xnxrzgsJBHr0+JpWKkaGoeYMZcyTe1c=;
        b=YCyJ+SrHGHjsFyI9HTPmshyrhJ3CV4AzAOGI7Sx80KfUIzjoioV13j28QqPbwxsYd5
         u0neTxvlUUJSpQIObXtHHCT7jvudcVKp/6CFdxOpOKfk7KtVtiWr0ttE2oK6FvKqjWGb
         BHzyvAATbPcZD5xYq8lEkM3f6WRQ+TdTPvLBOjogH3zbaFOMut2gVbHauZHU/flQzqVf
         xD3/jIkaQ/NPsn0GNHw6XJW2xeG6B1fKX50waiSgruwz6dD0lbYvOqetL/qSwLEBgnFJ
         5EtY22FO7rC4PsqdehRof975BH2Ya/UIe+7elCaf8rABLmM7UWC2DprFd638keccAFMU
         AycQ==
X-Forwarded-Encrypted: i=1; AJvYcCVvr7EkEPKGJtHqSy9yk2apPtX7p1ZHfJEgfsXTyFZeEkg/2iLM+lSFsua+ykAw65uPQ5t9yHMG@bugs.debian.org
X-Gm-Message-State: AOJu0YxRk2mB3TVOgguz9NbmVWhTZ9Lc9DtQvWmCq1j8VfXeHkURPFt6
	1fvGc80wxKsUw2H9lVphp/+jWq0xFpg8zAMitxjnskvmycQOZHIiDzRaA2CJoKTz1tjK9q1p6Ay
	6mrABOsM4dN6BBuk/l4KebAH5uf9eszLDkuswXJnXiRB34dVHk+H0qVv1Rw==
X-Gm-Gg: ASbGncvIggDQEOfQsxMKOJ53GfbgOWQKrNZit3jatTBcsgzvSSTmIMW11Dwy5Wc08Xe
	iRGCZbfa/mcru6FUvoSeFGvuWaP8A+bnKzMOLsLE1WDATwtYkBYy38fUBlPg8swZ90skAXchiIb
	EYmeXJPfh78MlDh3VSEzafD7fKj4lueBqLsTrtKdCpzgdwc8e1N5K61wr2OHNsksohfS23R7XHb
	gU76ZSg9ogITnf9cCY+631GKD0wkyhxuGNT00kl8bECGDAdTkNboNqBZQSJ4HHz8fWj36KY3R8a
	Ds1dVos8hOCLWzbJI5oOJNQLWUlXzX1f+Z5Wortp1k6lI0uy4Vtq3fo9/Pkn
X-Received: by 2002:a05:600c:6287:b0:46f:b42e:e38d with SMTP id 5b1f17b1804b1-46fb42ee464mr129131655e9.40.1760520195774;
        Wed, 15 Oct 2025 02:23:15 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHo4aFhSJSTlALL31iQKgpUlgPdwn2S5YN/PB9wP6hWkWwUl/VD01rI31zi/33P6LICiYPvbA==
X-Received: by 2002:a05:600c:6287:b0:46f:b42e:e38d with SMTP id 5b1f17b1804b1-46fb42ee464mr129131465e9.40.1760520195303;
        Wed, 15 Oct 2025 02:23:15 -0700 (PDT)
Received: from thinky (ip-217-030-074-039.aim-net.cz. [217.30.74.39])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-47101be0caasm18398985e9.3.2025.10.15.02.23.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 15 Oct 2025 02:23:15 -0700 (PDT)
Date: Wed, 15 Oct 2025 11:23:13 +0200
From: Andrey Albershteyn <aalbersh@redhat.com>
To: "Darrick J. Wong" <djwong@kernel.org>, 1116595@bugs.debian.org
Cc: Iustin Pop <iustin@debian.org>, xfs <linux-xfs@vger.kernel.org>
Message-ID: <ztwmr6d7wgvhedjdz37zk3fczqwug23kbxpxoau5ut7svjz7hs@jyd6siyqbyrr>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <20251013233424.GT6188@frogsfrogsfrogs>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: r1ZXBM0YdpX6NLHkqWa-CYZ94x9WqIY87jvyA_rT7GY_1760520196
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Greylist: delayed 367 seconds by postgrey-1.37 at buxtehude; Wed, 15 Oct 2025 09:29:28 UTC
Message-ID: <20251015092313.Aq3MZI-0DGJW79qUCFDKTmeBFriFjlAs-Lw5P32yJ20@z>

On 2025-10-13 16:34:24, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> Iustin Pop reports that the xfs_scrub_fail service fails to email
> problem reports on Debian when postfix is installed.  This is apparently
> due to several factors:
> 
> 1. postfix's sendmail wrapper calling postdrop directly,
> 2. postdrop requiring the ability to write to the postdrop group,
> 3. lockdown preventing the xfs_scrub_fail@ service to have postdrop in
>    the supplemental group list or the ability to run setgid programs
> 
> Item (3) could be solved by adding the whole service to the postdrop
> group via SupplementalGroups=, but that will fail if postfix is not
> installed and hence there is no postdrop group.
> 
> It could also be solved by forcing msmtp to be installed, bind mounting
> msmtp into the service container, and injecting a config file that
> instructs msmtp to connect to port 25, but that in turn isn't compatible
> with systems not configured to allow an smtp server to listen on ::1.
> 
> So we'll go with the less restrictive approach that e2scrub_fail@ does,
> which is to say that we just turn off all the sandboxing. :( :(
> 
> Reported-by: iustin@debian.org
> Cc: <linux-xfs@vger.kernel.org> # v6.10.0
> Fixes: 9042fcc08eed6a ("xfs_scrub_fail: tighten up the security on the background systemd service")
> Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>

lgtm
Reviewed-by: Andrey Albershteyn <aalbersh@kernel.org>

> ---
>  scrub/xfs_scrub_fail@.service.in |   57 ++------------------------------------
>  1 file changed, 3 insertions(+), 54 deletions(-)
> 
> diff --git a/scrub/xfs_scrub_fail@.service.in b/scrub/xfs_scrub_fail@.service.in
> index 16077888df3391..1e205768133467 100644
> --- a/scrub/xfs_scrub_fail@.service.in
> +++ b/scrub/xfs_scrub_fail@.service.in
> @@ -19,57 +19,6 @@ SupplementaryGroups=systemd-journal
>  # can control resource usage.
>  Slice=system-xfs_scrub.slice
>  
> -# No realtime scheduling
> -RestrictRealtime=true
> -
> -# Make the entire filesystem readonly and /home inaccessible.
> -ProtectSystem=full
> -ProtectHome=yes
> -PrivateTmp=true
> -RestrictSUIDSGID=true
> -
> -# Emailing reports requires network access, but not the ability to change the
> -# hostname.
> -ProtectHostname=true
> -
> -# Don't let the program mess with the kernel configuration at all
> -ProtectKernelLogs=true
> -ProtectKernelModules=true
> -ProtectKernelTunables=true
> -ProtectControlGroups=true
> -ProtectProc=invisible
> -RestrictNamespaces=true
> -
> -# Can't hide /proc because journalctl needs it to find various pieces of log
> -# information
> -#ProcSubset=pid
> -
> -# Only allow the default personality Linux
> -LockPersonality=true
> -
> -# No writable memory pages
> -MemoryDenyWriteExecute=true
> -
> -# Don't let our mounts leak out to the host
> -PrivateMounts=true
> -
> -# Restrict system calls to the native arch and only enough to get things going
> -SystemCallArchitectures=native
> -SystemCallFilter=@system-service
> -SystemCallFilter=~@privileged
> -SystemCallFilter=~@resources
> -SystemCallFilter=~@mount
> -
> -# xfs_scrub needs these privileges to run, and no others
> -CapabilityBoundingSet=
> -NoNewPrivileges=true
> -
> -# Failure reporting shouldn't create world-readable files
> -UMask=0077
> -
> -# Clean up any IPC objects when this unit stops
> -RemoveIPC=true
> -
> -# No access to hardware device files
> -PrivateDevices=true
> -ProtectClock=true
> +# No further restrictions because some installations may have MTAs such as
> +# postfix, which require the ability to run setgid programs and other
> +# foolishness.
> 

-- 
- Andrey
