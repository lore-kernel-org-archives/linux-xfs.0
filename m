Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7E97BC433F5
	for <linux-xfs@archiver.kernel.org>; Fri,  5 Nov 2021 14:17:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4B38660FC2
	for <linux-xfs@archiver.kernel.org>; Fri,  5 Nov 2021 14:17:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233017AbhKEOUF (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 5 Nov 2021 10:20:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52502 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232410AbhKEOUF (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 5 Nov 2021 10:20:05 -0400
Received: from gwu.lbox.cz (proxybox.linuxbox.cz [IPv6:2a02:8304:2:66::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D89C3C061714
        for <linux-xfs@vger.kernel.org>; Fri,  5 Nov 2021 07:17:25 -0700 (PDT)
Received: from linuxbox.linuxbox.cz (linuxbox.linuxbox.cz [10.76.66.10])
        by gwu.lbox.cz (Sendmail) with ESMTPS id 1A5EHKA6013967
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO);
        Fri, 5 Nov 2021 15:17:20 +0100
DKIM-Filter: OpenDKIM Filter v2.11.0 gwu.lbox.cz 1A5EHKA6013967
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxbox.cz;
        s=default; t=1636121842;
        bh=0kgafY8zhGuX2OGrSBr3jtyQGyG51wv3+CAS4zBe1cI=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=MXVfwPz+xs6y3RTqOKM+hto/ANiPrG0gOe5JcCpCmT4xVliFuIJS6E+4SspHXQ5KV
         CwiEiD+4Rljgv2mIFVtGdYdPbB/iIDrLw230vumvt8tI5t+8/VH7z6NM1iahvbJ3PI
         tfO3kAWgXM4TY3qMagQHkUwIIHlqhZZIUD47EpvU=
Received: from pcnci.linuxbox.cz (pcnci.linuxbox.cz [10.76.3.14])
        by linuxbox.linuxbox.cz (Sendmail) with ESMTPS id 1A5EHKUQ002400
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO);
        Fri, 5 Nov 2021 15:17:20 +0100
Received: from pcnci.linuxbox.cz (localhost [127.0.0.1])
        by pcnci.linuxbox.cz (8.15.2/8.15.2) with SMTP id 1A5EHJNs010672;
        Fri, 5 Nov 2021 15:17:19 +0100
Date:   Fri, 5 Nov 2021 15:17:19 +0100
From:   Nikola Ciprich <nikola.ciprich@linuxbox.cz>
To:     Eric Sandeen <sandeen@sandeen.net>
Cc:     linux-xfs@vger.kernel.org,
        Nikola Ciprich <nikola.ciprich@linuxbox.cz>
Subject: Re: XFS / xfs_repair - problem reading very large sparse files on
 very large filesystem
Message-ID: <20211105141719.GI32555@pcnci.linuxbox.cz>
References: <20211104090915.GW32555@pcnci.linuxbox.cz>
 <39784566-4696-2391-a6f5-6891c2c7802b@sandeen.net>
 <20211105141343.GH32555@pcnci.linuxbox.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211105141343.GH32555@pcnci.linuxbox.cz>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Scanned-By: MIMEDefang 2.85 on 10.76.66.2
X-Scanned-By: MIMEDefang v2.85/SpamAssassin v3.004006 on lbxovapx.linuxbox.cz (nik)
X-Scanned-By: MIMEDefang 2.85 on 10.76.66.10
X-Antivirus: on lbxovapx.linuxbox.cz by Kaspersky antivirus, database version: 2021-11-05T13:09:00
X-Milter-Copy-Status: O
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

> > I'm guessing they are horrifically fragmented? What does xfs_bmap tell you
> > about the number of extents in one of these files?
> 
> unfortunately, xfs_bmap blocks on this file too:

anyways, trying to run it on another similar file, which doesn't seem
to suffer such problem (of 10TB size) shows 680657 allocation
groups which I guess is not very good..

here's the output if it is of some use:

https://storage.linuxbox.cz/index.php/s/AyZGW5Xdfxg47f6


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
