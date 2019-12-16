Return-Path: <SRS0=k6ZN=2G=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ECC0BC43603
	for <linux-xfs@archiver.kernel.org>; Mon, 16 Dec 2019 09:36:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BDC392075A
	for <linux-xfs@archiver.kernel.org>; Mon, 16 Dec 2019 09:36:05 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="KpVe2GES"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727015AbfLPJgF (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 16 Dec 2019 04:36:05 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:26251 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726881AbfLPJgF (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 16 Dec 2019 04:36:05 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1576488964;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=zSNyJVDQQRShHLUJMx+I06u7S4GHKJEzYoSM/fhjhl0=;
        b=KpVe2GESAxSkhqJFEkvvSCeB8C/0YkeGP3d5R3G00QXd6pO8ngnG8Wj2QIzqpLdREcgObm
        0yHrsd1Bb3UHKiuf+aIECliZ0aC+66xALbntSzHHgG4Vwr2y9NAPznatxSUyoLH+wjIlGo
        b7Qrs5nvA9KxxrqhlrF6CQd7NmeagWg=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-75-QCQZ98AKMk6Kop7BNnLi_A-1; Mon, 16 Dec 2019 04:36:02 -0500
X-MC-Unique: QCQZ98AKMk6Kop7BNnLi_A-1
Received: by mail-wr1-f72.google.com with SMTP id j13so3443688wrr.20
        for <linux-xfs@vger.kernel.org>; Mon, 16 Dec 2019 01:36:02 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id
         :mail-followup-to:references:mime-version:content-disposition
         :content-transfer-encoding:in-reply-to;
        bh=zSNyJVDQQRShHLUJMx+I06u7S4GHKJEzYoSM/fhjhl0=;
        b=n9uxkPURHxrd8VmlOERsqkGI3ZgkGnjGPN0SXwKTDqDqx0ty/0dS/Q8poKv+yipoQ5
         VN2luP+iXfa7jyCCgyBLXc+3yjHgc5pYXztZufidWCaMwMcK2BVpx9RMY4PgBJrU1tFs
         rfZj7VNLny+R9hcetKegl3IwrRLb/dz5nyO0NOTRILHOzlR+XXnxXopFJpoPNNk8z2NN
         Lb4Ahe7tbhRuWcT/dFa1f9cNzyM3tTRaCsxGhmYz6f/FhuUzxPzE7XLYvBfPFZdjIk5V
         NgReeN8p8Ky1eM4wmV0rXvvto6TjY4pYQcMX+XNF+ZEwvVkkWdBLcVNH6xvz9RmB7b49
         D9DA==
X-Gm-Message-State: APjAAAX5NLDn/I/2b4L1Zp5Xz0/a9/9YMJwvN90FdnvBw/QPhJ0+ZuF9
        6Qoxsr1shQSX3szdC0Rq8UJGIQA747AhEQBTdh1k59+wsX+WRVGXeZjXlFb+S+glXG5pgf66D6G
        6YmsUHxFCWJP9yByls+jM
X-Received: by 2002:a7b:c407:: with SMTP id k7mr29989642wmi.46.1576488960985;
        Mon, 16 Dec 2019 01:36:00 -0800 (PST)
X-Google-Smtp-Source: APXvYqwRrLkYcQb78YO6pW50jZPw7PzUtEfqQAiUKG8CT/bAx6EnRhpIUN902jFhbm+mxHE/24TLcQ==
X-Received: by 2002:a7b:c407:: with SMTP id k7mr29989631wmi.46.1576488960727;
        Mon, 16 Dec 2019 01:36:00 -0800 (PST)
Received: from orion (ip-89-103-126-188.net.upcbroadband.cz. [89.103.126.188])
        by smtp.gmail.com with ESMTPSA id a16sm20765369wrt.37.2019.12.16.01.35.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 16 Dec 2019 01:35:59 -0800 (PST)
Date:   Mon, 16 Dec 2019 10:35:57 +0100
From:   Carlos Maiolino <cmaiolino@redhat.com>
To:     "Enrico Weigelt, metux IT consult" <lkml@metux.net>
Cc:     Damien Le Moal <damien.lemoal@wdc.com>,
        linux-fsdevel@vger.kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 0/2] New zonefs file system
Message-ID: <20191216093557.2vackj7qakk2jngd@orion>
Mail-Followup-To: "Enrico Weigelt, metux IT consult" <lkml@metux.net>,
        Damien Le Moal <damien.lemoal@wdc.com>,
        linux-fsdevel@vger.kernel.org, linux-xfs@vger.kernel.org
References: <20191212183816.102402-1-damien.lemoal@wdc.com>
 <29fb138e-e9e5-5905-5422-4454c956e685@metux.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <29fb138e-e9e5-5905-5422-4454c956e685@metux.net>
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Dec 16, 2019 at 09:18:23AM +0100, Enrico Weigelt, metux IT consult wrote:
> On 12.12.19 19:38, Damien Le Moal wrote:
> 
> Hi,
> 
> > zonefs is a very simple file system exposing each zone of a zoned block
> > device as a file. Unlike a regular file system with zoned block device
> > support (e.g. f2fs or the on-going btrfs effort), zonefs does not hide
> > the sequential write constraint of zoned block devices to the user.
> 
> Just curious: what's the exact definition of "zoned" here ?
> Something like partitions ?

Zones inside a SMR HDD.

> 
> Can these files then also serve as block devices for other filesystems ?
> Just a funny idea: could we handle partitions by a file system ?
> 
> Even more funny idea: give file systems block device ops, so they can
> be directly used as such (w/o explicitly using loopdev) ;-)
> 
> > Files representing sequential write zones of the device must be written
> > sequentially starting from the end of the file (append only writes).
> 
> So, these files can only be accessed like a tape ?

On a SMR HDD, each zone can only be written sequentially, due to physics
constraints. I won't post any link with references because I think majordomo
will spam my email if I do, but do a google search of something like 'SMR HDD
zones' and you'll get a better idea


> 
> Assuming you're working ontop of standard block devices anyways (instead
> of tape-like media ;-)) - why introducing such a limitation ?

The limitation is already there on SMR drives, some of them (Device Managed
models), just hide it from the system.

> 
> > zonefs is not a POSIX compliant file system. It's goal is to simplify
> > the implementation of zoned block devices support in applications by
> > replacing raw block device file accesses with a richer file based API,
> > avoiding relying on direct block device file ioctls which may
> > be more obscure to developers. 
> 
> ioctls ?
> 
> Last time I checked, block devices could be easily accessed via plain
> file ops (read, write, seek, ...). You can basically treat them just
> like big files of fixed size.
> 
> > One example of this approach is the
> > implementation of LSM (log-structured merge) tree structures (such as
> > used in RocksDB and LevelDB)
> 
> The same LevelDB as used eg. in Chrome browser, which destroys itself
> every time a little temporary problem (eg. disk full) occours ?
> If that's the usecase I'd rather use an simple in-memory table instead
> and and enough swap, as leveldb isn't reliable enough for persistent
> data anyways :p
> 
> > on zoned block devices by allowing SSTables
> > to be stored in a zone file similarly to a regular file system rather
> > than as a range of sectors of a zoned device. The introduction of the
> > higher level construct "one file is one zone" can help reducing the
> > amount of changes needed in the application while at the same time
> > allowing the use of zoned block devices with various programming
> > languages other than C.
> 
> Why not just simply use files on a suited filesystem (w/ low block io
> overhead) or LVM volumes ?
> 
> 
> --mtx
> 
> -- 
> Dringender Hinweis: aufgrund existenzieller Bedrohung durch "Emotet"
> sollten Sie *niemals* MS-Office-Dokumente via E-Mail annehmen/öffenen,
> selbst wenn diese von vermeintlich vertrauenswürdigen Absendern zu
> stammen scheinen. Andernfalls droht Totalschaden.
> ---
> Hinweis: unverschlüsselte E-Mails können leicht abgehört und manipuliert
> werden ! Für eine vertrauliche Kommunikation senden Sie bitte ihren
> GPG/PGP-Schlüssel zu.
> ---
> Enrico Weigelt, metux IT consult
> Free software and Linux embedded engineering
> info@metux.net -- +49-151-27565287
> 

-- 
Carlos

