Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E3DA7C433FE
	for <linux-xfs@archiver.kernel.org>; Fri,  5 Nov 2021 16:19:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C629760187
	for <linux-xfs@archiver.kernel.org>; Fri,  5 Nov 2021 16:19:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233233AbhKEQWf (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 5 Nov 2021 12:22:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52622 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233212AbhKEQWe (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 5 Nov 2021 12:22:34 -0400
Received: from gwu.lbox.cz (proxybox.linuxbox.cz [IPv6:2a02:8304:2:66::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 72B52C061205
        for <linux-xfs@vger.kernel.org>; Fri,  5 Nov 2021 09:19:54 -0700 (PDT)
Received: from linuxbox.linuxbox.cz (linuxbox.linuxbox.cz [10.76.66.10])
        by gwu.lbox.cz (Sendmail) with ESMTPS id 1A5GJlL7030910
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO);
        Fri, 5 Nov 2021 17:19:47 +0100
DKIM-Filter: OpenDKIM Filter v2.11.0 gwu.lbox.cz 1A5GJlL7030910
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxbox.cz;
        s=default; t=1636129187;
        bh=XL3ljO9f1UE3IlaN9eVzRqt0BRxKN2fha8E0QoUT/6w=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=RCrDd21F3CQbFikrbwd9IKost1BBKKrn+ecK5vghFKQn0dhxL5aPkDn7pS6INDkr8
         djpa/9+vSjM9UyQZLl71LSSi9QphDluV34KT/z1XSyzxqSVBrym0hQ1c5pIxcyTTP2
         5YM0MoSG31XymK/mPRa6SrWf87B/Nvg72SqfIASM=
Received: from pcnci.linuxbox.cz (pcnci.linuxbox.cz [10.76.3.14])
        by linuxbox.linuxbox.cz (Sendmail) with ESMTPS id 1A5GJlSd012401
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO);
        Fri, 5 Nov 2021 17:19:47 +0100
Received: from pcnci.linuxbox.cz (localhost [127.0.0.1])
        by pcnci.linuxbox.cz (8.15.2/8.15.2) with SMTP id 1A5GJlCP013251;
        Fri, 5 Nov 2021 17:19:47 +0100
Date:   Fri, 5 Nov 2021 17:19:47 +0100
From:   Nikola Ciprich <nikola.ciprich@linuxbox.cz>
To:     Eric Sandeen <esandeen@redhat.com>
Cc:     Eric Sandeen <sandeen@sandeen.net>, linux-xfs@vger.kernel.org,
        Nikola Ciprich <nikola.ciprich@linuxbox.cz>
Subject: Re: XFS / xfs_repair - problem reading very large sparse files on
 very large filesystem
Message-ID: <20211105161947.GK32555@pcnci.linuxbox.cz>
References: <20211104090915.GW32555@pcnci.linuxbox.cz>
 <39784566-4696-2391-a6f5-6891c2c7802b@sandeen.net>
 <20211105141343.GH32555@pcnci.linuxbox.cz>
 <20211105141719.GI32555@pcnci.linuxbox.cz>
 <6af37cfb-1136-6d07-45a0-c0494b64b0d7@redhat.com>
 <20211105155914.GJ32555@pcnci.linuxbox.cz>
 <48920430-e48b-0531-2627-0efee9845a1c@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <48920430-e48b-0531-2627-0efee9845a1c@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Scanned-By: MIMEDefang 2.85 on 10.76.66.2
X-Scanned-By: MIMEDefang v2.85/SpamAssassin v3.004006 on lbxovapx.linuxbox.cz (nik)
X-Scanned-By: MIMEDefang 2.85 on 10.76.66.10
X-Antivirus: on lbxovapx.linuxbox.cz by Kaspersky antivirus, database version: 2021-11-05T13:09:00
X-Milter-Copy-Status: O
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

> 
> ok, thanks for the clarification.

no problem... in the meantime, xfs_bmap finished as well,
resulting output has 1.5GB, showing total of 25354643 groups :-O

> 
> Though I've never heard of streaming video writes that weren't sequential ...
> have you actually observed that via strace or whatnot?
those are streams from many cameras, somehow multiplexed by processing software.
The guy I communicate with, whos responsible unfortunately does not know
many details


> 
> What might be happening is that if you are streaming multiple files into a single
> directory at the same time, it competes for the allocator, and they will interleave.
> 
> XFS has an allocator mode called "filestreams" which was designed just for this
> (video ingest).
thanks for the tip, I'll check that!

anyways I'll rather preallocate files fully for now, it takes a lot of time, but
should be the safest way before we know what exactly is wrong.. and I'll also
avoid creating such huge filesystems, as it leads to more trouble.. (like needs of huge
amounts of RAM for fs repair)

> 
> If you set the "S" attribute on the target directory, IIRC it should enable this
> mode.  You can do that with the xfs_io "chattr" command.
> 
> Might be worth a test, or wait for dchinner to chime in on whether this is a
> reasonable suggestion...
OK

BR

nik



> 
> -Eric
> 
> >btw blocked read from file I sent backtrace seems to have started finally (after
> >maybe an hour) and runs 8-20MB/s
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
