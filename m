Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DDD1FC83F12
	for <linux-xfs@archiver.kernel.org>; Tue, 29 Aug 2023 06:39:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231410AbjH2GjT (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 29 Aug 2023 02:39:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38984 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232235AbjH2GjL (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 29 Aug 2023 02:39:11 -0400
Received: from buxtehude.debian.org (buxtehude.debian.org [IPv6:2607:f8f0:614:1::1274:39])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BE1C818D
        for <linux-xfs@vger.kernel.org>; Mon, 28 Aug 2023 23:39:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=bugs.debian.org; s=smtpauto.buxtehude; h=Content-Type:Date:Reply-To:
        References:Message-ID:Subject:To:From:MIME-Version:Cc:
        Content-Transfer-Encoding:Content-ID:Content-Description:In-Reply-To;
        bh=5aRkXuXFMV4HgMGmuc1WRbaXoVDOLh7oBUce4wiIz10=; b=R6ryA7VUp58jwgTfMwp6pjVg8s
        rlyPYzRdQ45QrmpFSvJyltSTe7YdZeNGnvVEhUGgrltZB8+/FYjoDfOx0CSDd+yeTg1AZIwd05Hhu
        5NF/akkqUfTv0U3TYEDGk9aYR0Hhy/psP04ABnLxBGUbXHjrUYbeKKu5pXxch3M+x882iczsZUXjr
        0OGl67hNkgnhSd1PYQWfE/xnti4yjP1O+lVuAYzjax/PQUFRMoHXfOVh6IGxLNT7dI0FdfHxYRGip
        aOV02PxfiQ9w8bzI+1InDDQzj7mL7X21u4kAHv31nyq0iJeXnkkaey9hWTMe6pG42PdW5PdwobAFN
        RCJmaWtg==;
Received: from debbugs by buxtehude.debian.org with local (Exim 4.94.2)
        (envelope-from <debbugs@buxtehude.debian.org>)
        id 1qasNS-00AnH9-Mk; Tue, 29 Aug 2023 06:39:02 +0000
MIME-Version: 1.0
X-Mailer: MIME-tools 5.509 (Entity 5.509)
X-Loop: owner@bugs.debian.org
From:   "Debian Bug Tracking System" <owner@bugs.debian.org>
To:     Bastian Germann <bage@debian.org>
Subject: Bug#905052: marked as done (xfslibs-dev: broken symlink:
 /lib/libhandle.a -> /usr/lib/libhandle.a)
Message-ID: <handler.905052.D905052.16932909102570768.ackdone@bugs.debian.org>
References: <e5d84408-565e-4f6c-99ef-fd0a4f555e21@debian.org>
 <153299418305.2496.15162238619919817531.reportbug@zam581.zam.kfa-juelich.de>
X-Debian-PR-Message: closed 905052
X-Debian-PR-Package: xfslibs-dev
X-Debian-PR-Keywords: confirmed buster
X-Debian-PR-Source: xfsprogs
Reply-To: 905052@bugs.debian.org
Date:   Tue, 29 Aug 2023 06:39:02 +0000
Content-Type: multipart/mixed; boundary="----------=_1693291142-2572663-0"
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

This is a multi-part message in MIME format...

------------=_1693291142-2572663-0
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="utf-8"

Your message dated Tue, 29 Aug 2023 08:35:04 +0200
with message-id <e5d84408-565e-4f6c-99ef-fd0a4f555e21@debian.org>
and subject line Re: xfslibs-dev: broken symlink: /lib/libhandle.a -> /usr/=
lib/libhandle.a
has caused the Debian Bug report #905052,
regarding xfslibs-dev: broken symlink: /lib/libhandle.a -> /usr/lib/libhand=
le.a
to be marked as done.

This means that you claim that the problem has been dealt with.
If this is not the case it is now your responsibility to reopen the
Bug report if necessary, and/or fix the problem forthwith.

(NB: If you are a system administrator and have no idea what this
message is talking about, this may indicate a serious mail system
misconfiguration somewhere. Please contact owner@bugs.debian.org
immediately.)


--=20
905052: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D905052
Debian Bug Tracking System
Contact owner@bugs.debian.org with problems

------------=_1693291142-2572663-0
Content-Type: message/rfc822
Content-Disposition: inline
Content-Transfer-Encoding: 7bit

Received: (at submit) by bugs.debian.org; 30 Jul 2018 23:43:05 +0000
X-Spam-Checker-Version: SpamAssassin 3.4.1-bugs.debian.org_2005_01_02
	(2015-04-28) on buxtehude.debian.org
X-Spam-Level: 
X-Spam-Status: No, score=-23.0 required=4.0 tests=BAYES_00,FOURLA,
	FROMDEVELOPER,HAS_PACKAGE,RCVD_IN_DNSWL_NONE,TXREP autolearn=ham
	autolearn_force=no version=3.4.1-bugs.debian.org_2005_01_02
X-Spam-Bayes: score:0.0000 Tokens: new, 15; hammy, 92; neutral, 24; spammy, 0.
	spammytokens: hammytokens:0.000-+--H*F:U*anbe, 0.000-+--H*RU:anbe@debian.org,
	0.000-+--H*rp:U*anbe, 0.000-+--Hx-spam-relays-external:anbe@debian.org,
	0.000-+--H*M:reportbug
Return-path: <anbe@debian.org>
Received: from web4.unixos.de ([85.214.109.88])
	by buxtehude.debian.org with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
	(Exim 4.89)
	(envelope-from <anbe@debian.org>)
	id 1fkHof-0003Am-Ag
	for submit@bugs.debian.org; Mon, 30 Jul 2018 23:43:05 +0000
Received: from web4.unixos.de (localhost [127.0.0.1])
	by web4.unixos.de (Postfix) with ESMTP id 9238160428;
	Tue, 31 Jul 2018 01:43:03 +0200 (CEST)
Received: from zam581.zam.kfa-juelich.de (zam581.zam.kfa-juelich.de [134.94.168.26])
	by web4.unixos.de (Postfix) with ESMTPSA id 679AA60427;
	Tue, 31 Jul 2018 01:43:03 +0200 (CEST)
Content-Type: multipart/mixed; boundary="===============9076312940431249723=="
MIME-Version: 1.0
From: Andreas Beckmann <anbe@debian.org>
To: Debian Bug Tracking System <submit@bugs.debian.org>
Subject: xfslibs-dev: broken symlink: /lib/libhandle.a -> /usr/lib/libhandle.a
Message-ID: <153299418305.2496.15162238619919817531.reportbug@zam581.zam.kfa-juelich.de>
Date: Tue, 31 Jul 2018 01:43:03 +0200
X-Virus-Scanned: ClamAV using ClamSMTP
Delivered-To: submit@bugs.debian.org

This is a multi-part MIME message sent by reportbug.


--===============9076312940431249723==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

Package: xfslibs-dev
Version: 4.15.1-1
Severity: normal
User: debian-qa@lists.debian.org
Usertags: piuparts

Hi,

during a test with piuparts I noticed your package ships (or creates)
a broken symlink.

From the attached log (scroll to the bottom...):

0m31.1s ERROR: FAIL: Broken symlinks:
  /lib/libhandle.a -> /usr/lib/libhandle.a


cheers,

Andreas

--===============9076312940431249723==
Content-Type: application/gzip
MIME-Version: 1.0
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="xfslibs-dev_4.15.1-1.log.gz"

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
Hy/+C2yyY7xz6QAA

--===============9076312940431249723==--

------------=_1693291142-2572663-0
Content-Type: message/rfc822
Content-Disposition: inline
Content-Transfer-Encoding: 7bit

Received: (at 905052-done) by bugs.debian.org; 29 Aug 2023 06:35:10 +0000
X-Spam-Checker-Version: SpamAssassin 3.4.6-bugs.debian.org_2005_01_02
	(2021-04-09) on buxtehude.debian.org
X-Spam-Level: 
X-Spam-Status: No, score=-106.2 required=4.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FROMDEVELOPER,
	SPF_HELO_NONE,SPF_NONE,TVD_SPACE_RATIO,UNPARSEABLE_RELAY,
	USER_IN_DKIM_WELCOMELIST,USER_IN_DKIM_WHITELIST,VERSION autolearn=ham
	autolearn_force=no version=3.4.6-bugs.debian.org_2005_01_02
X-Spam-Bayes: score:0.0000 Tokens: new, 17; hammy, 87; neutral, 13; spammy, 0.
	spammytokens: hammytokens:0.000-+--Hx-spam-relays-external:sk:stravin,
	0.000-+--H*RT:sk:stravin, 0.000-+--Hx-spam-relays-external:311,
	0.000-+--H*RT:108, 0.000-+--H*RT:311
Return-path: <bage@debian.org>
Received: from stravinsky.debian.org ([2001:41b8:202:deb::311:108]:50336)
	from C=NA,ST=NA,L=Ankh Morpork,O=Debian SMTP,OU=Debian SMTP CA,CN=stravinsky.debian.org,EMAIL=hostmaster@stravinsky.debian.org (verified)
	by buxtehude.debian.org with esmtps (TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.94.2)
	(envelope-from <bage@debian.org>)
	id 1qasJi-00Amlr-Af
	for 905052-done@bugs.debian.org; Tue, 29 Aug 2023 06:35:10 +0000
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=debian.org;
	s=smtpauto.stravinsky; h=X-Debian-User:Content-Transfer-Encoding:Content-Type
	:In-Reply-To:From:Subject:References:To:MIME-Version:Date:Message-ID:Reply-To
	:Cc:Content-ID:Content-Description;
	bh=L/F0mn19kV2tmTCQqLAGXLPyF58gh2gJakT6vk+13cA=; b=JybC+iYX2Zo/3wVpucd+9F1pnD
	03AfSWwbOazQInjfn2CKgAjTrSZ0wss7jNzBOfqCkQADMlqFpWahXRw6l0U4NqAfc/6KKykiH+dke
	8gTeAn5FP6vEhSBwJ9bfRb4Yrk/mDg4tuEtjltmOOok2441MSEhKCxjpWWVF2gxSMoNyWAKm8j51J
	+JgeGT91e4EbxDC0hFIHvOc+KNR1PhY1vFKHsbI0X+XInnghgqZbZWAQiy+vfFRSRopI/eyGBRZ1K
	zt5gmYVq+ayirLqc01vznPzR44c6GM8m5SjnjeZ5jF3fCcEztZaHchvKuucTHGL9SzKK8+txe6QlF
	w6CG9vYQ==;
Received: from authenticated user
	by stravinsky.debian.org with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_128_GCM:128)
	(Exim 4.94.2)
	(envelope-from <bage@debian.org>)
	id 1qasJg-0098Xs-08
	for 905052-done@bugs.debian.org; Tue, 29 Aug 2023 06:35:08 +0000
Message-ID: <e5d84408-565e-4f6c-99ef-fd0a4f555e21@debian.org>
Date: Tue, 29 Aug 2023 08:35:04 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
To: 905052-done@bugs.debian.org
References: <153299418305.2496.15162238619919817531.reportbug@zam581.zam.kfa-juelich.de>
 <153299418305.2496.15162238619919817531.reportbug@zam581.zam.kfa-juelich.de>
Subject: Re: xfslibs-dev: broken symlink: /lib/libhandle.a ->
 /usr/lib/libhandle.a
Content-Language: en-US
From: Bastian Germann <bage@debian.org>
In-Reply-To: <153299418305.2496.15162238619919817531.reportbug@zam581.zam.kfa-juelich.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Debian-User: bage

Version: xfsprogs/5.6.0-1
------------=_1693291142-2572663-0--
