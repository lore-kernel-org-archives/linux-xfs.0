Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-pg1-f195.google.com ([209.85.215.195]:42477 "EHLO
        mail-pg1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726811AbfGLRKS (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 12 Jul 2019 13:10:18 -0400
Received: by mail-pg1-f195.google.com with SMTP id t132so4796600pgb.9
        for <linux-xfs@vger.kernel.org>; Fri, 12 Jul 2019 10:10:18 -0700 (PDT)
Message-ID: <1562951415.2741.18.camel@dubeyko.com>
Subject: Re: [PATCH RFC] fs: New zonefs file system
From: Viacheslav Dubeyko <slava@dubeyko.com>
Date: Fri, 12 Jul 2019 10:10:15 -0700
In-Reply-To: <20190712030017.14321-1-damien.lemoal@wdc.com>
References: <20190712030017.14321-1-damien.lemoal@wdc.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Damien Le Moal <damien.lemoal@wdc.com>, linux-fsdevel@vger.kernel.org, linux-xfs@vger.kernel.org, Christoph Hellwig <hch@lst.de>
Cc: Johannes Thumshirn <jthumshirn@suse.de>, Hannes Reinecke <hare@suse.de>

On Fri, 2019-07-12 at 12:00 +0900, Damien Le Moal wrote:
> zonefs is a very simple file system exposing each zone of a zoned
> block device as a file. This is intended to simplify implementation 

As far as I can see, a zone usually is pretty big in size (for example,
256MB). But [1, 2] showed that about 60% of files on a file system
volume has size about 4KB - 128KB. Also [3] showed that modern
application uses a very complex files' structures that are updated in
random order. Moreover, [4] showed that 90% of all files are not used
after initial creation, those that are used are normally short-lived,
and that if a file is not used in some manner the day after it is
created, it will probably never be used; 1% of all files are used
daily.

It sounds for me that mostly this approach will lead to waste of zones'
space. Also, the necessity to update data of the same file will be
resulted in frequent moving of files' data from one zone to another
one. If we are talking about SSDs then it sounds like quick and easy
way to kill this device fast.

Do you have in mind some special use-case?

Thanks,
Viacheslav Dubeyko.


[1] Agrawal, et al., “A Five-Year Study of File-System Metadata,” ACM
Transactions on Storage (TOS), vol. 3 Issue 3, Oct. 2007, Article No.
9.
[2] Douceur, et al., “A Large-Scale Study of File-System Contents,”
SIGMETRICS '99 Proceedings of the 1999 ACM SIGMETRICS international
conference on Measurement and modeling of computer systems, pp. 59-70,
May 1-4, 1999.
[3] Tyler Harter, Chris Dragga, Michael Vaughn, Andrea C. Arpaci-
Dusseau, and Remzi H. Arpaci-Dusseau, “A file is not a file:
understanding the I/O behavior of Apple desktop applications.” In
Proceedings of the Twenty-Third ACM Symposium on Operating Systems
Principles (SOSP '11). ACM, New York, NY, USA, 71-83.
[4] Tim Gibson, Ethan L. Miller, Darrell D. E. Long, “Long-term File
Activity and Inter-Reference Patterns.”
