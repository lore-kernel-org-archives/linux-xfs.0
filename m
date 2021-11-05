Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1415DC433F5
	for <linux-xfs@archiver.kernel.org>; Fri,  5 Nov 2021 15:59:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E0B8061245
	for <linux-xfs@archiver.kernel.org>; Fri,  5 Nov 2021 15:59:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232454AbhKEQCF (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 5 Nov 2021 12:02:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47914 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232285AbhKEQCE (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 5 Nov 2021 12:02:04 -0400
Received: from gwu.lbox.cz (proxybox.linuxbox.cz [IPv6:2a02:8304:2:66::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4D2D0C061714
        for <linux-xfs@vger.kernel.org>; Fri,  5 Nov 2021 08:59:23 -0700 (PDT)
Received: from linuxbox.linuxbox.cz (linuxbox.linuxbox.cz [10.76.66.10])
        by gwu.lbox.cz (Sendmail) with ESMTPS id 1A5FxFv1011636
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO);
        Fri, 5 Nov 2021 16:59:15 +0100
DKIM-Filter: OpenDKIM Filter v2.11.0 gwu.lbox.cz 1A5FxFv1011636
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxbox.cz;
        s=default; t=1636127955;
        bh=Rj4Mr6Xgwo2gNu0hvkV2099NQWpr/f5s0Pu3CmrSIuo=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=y/XHhUw97KyBEchZCGwwE5m4lSo8T4xU1TamwXX9qPh37maIIRkJbL1FLKMcdueRW
         XBGufeRNj39mNccTw4IHS4c1DiRN3egKmVLiQbsAHlQigc36atQSjwzhmZOvPqc/V5
         b+hEUsY4n1+C3UpPbxNgMmzygoysA9RiNueSV2Pg=
Received: from pcnci.linuxbox.cz (pcnci.linuxbox.cz [10.76.3.14])
        by linuxbox.linuxbox.cz (Sendmail) with ESMTPS id 1A5FxFC1010839
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO);
        Fri, 5 Nov 2021 16:59:15 +0100
Received: from pcnci.linuxbox.cz (localhost [127.0.0.1])
        by pcnci.linuxbox.cz (8.15.2/8.15.2) with SMTP id 1A5FxEnr012793;
        Fri, 5 Nov 2021 16:59:14 +0100
Date:   Fri, 5 Nov 2021 16:59:14 +0100
From:   Nikola Ciprich <nikola.ciprich@linuxbox.cz>
To:     Eric Sandeen <esandeen@redhat.com>
Cc:     Eric Sandeen <sandeen@sandeen.net>, linux-xfs@vger.kernel.org,
        Nikola Ciprich <nikola.ciprich@linuxbox.cz>
Subject: Re: XFS / xfs_repair - problem reading very large sparse files on
 very large filesystem
Message-ID: <20211105155914.GJ32555@pcnci.linuxbox.cz>
References: <20211104090915.GW32555@pcnci.linuxbox.cz>
 <39784566-4696-2391-a6f5-6891c2c7802b@sandeen.net>
 <20211105141343.GH32555@pcnci.linuxbox.cz>
 <20211105141719.GI32555@pcnci.linuxbox.cz>
 <6af37cfb-1136-6d07-45a0-c0494b64b0d7@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6af37cfb-1136-6d07-45a0-c0494b64b0d7@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Scanned-By: MIMEDefang 2.85 on 10.76.66.2
X-Scanned-By: MIMEDefang v2.85/SpamAssassin v3.004006 on lbxovapx.linuxbox.cz (nik)
X-Scanned-By: MIMEDefang 2.85 on 10.76.66.10
X-Antivirus: on lbxovapx.linuxbox.cz by Kaspersky antivirus, database version: 2021-11-05T13:09:00
X-Milter-Copy-Status: O
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

> >
> >here's the output if it is of some use:
> >
> >https://storage.linuxbox.cz/index.php/s/AyZGW5Xdfxg47f6
> 
> Just to be clear - I think Dave and I interpreted your original email slightly
> differently.
> 
> Are these large files on the 1.5PB filesystem filesystem images themselves,
> or some other type of file?
> 
> And - the repair you were running was against the 1.5PB filesystem?
> 
> (see also Dave's reply in this thread)
> 
Hello Eric,

I was running fsck on the 1.5PB fs (I interrupted it, as it doesn't seem
to be the main problem now). Large files are archives of videofiles from camera
streaming software, I don't know much about them, I was told at the beginning
that all writes will be sequential, which apparently are not, so for new
files, we'll be preallocating them.

btw blocked read from file I sent backtrace seems to have started finally (after
maybe an hour) and runs 8-20MB/s

nik

> -Eric


> 

-- 
-------------------------------------
Ing. Nikola CIPRICH
LinuxBox.cz, s.r.o.
28.rijna 168, 709 00 Ostrava

tel.:   +420 591 166 214
fax:    +420 596 621 273
mobil:  +420 777 093 799
www.linuxbox.cz

mobil servis: +420 737 238 656
email servis: servis@linuxbox.cz
-------------------------------------
