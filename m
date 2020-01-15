Return-Path: <SRS0=S7Al=3E=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 301E8C33CB1
	for <linux-xfs@archiver.kernel.org>; Wed, 15 Jan 2020 10:21:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0336A2075B
	for <linux-xfs@archiver.kernel.org>; Wed, 15 Jan 2020 10:21:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729652AbgAOKVs convert rfc822-to-8bit (ORCPT
        <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 15 Jan 2020 05:21:48 -0500
Received: from eu-smtp-delivery-151.mimecast.com ([207.82.80.151]:43913 "EHLO
        eu-smtp-delivery-151.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729640AbgAOKVs (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 15 Jan 2020 05:21:48 -0500
Received: from AcuMS.aculab.com (156.67.243.126 [156.67.243.126]) (Using
 TLS) by relay.mimecast.com with ESMTP id
 uk-mta-224-1qiFO4UbN9aTPeO6iSwoTA-1; Wed, 15 Jan 2020 10:21:46 +0000
Received: from AcuMS.Aculab.com (fd9f:af1c:a25b:0:43c:695e:880f:8750) by
 AcuMS.aculab.com (fd9f:af1c:a25b:0:43c:695e:880f:8750) with Microsoft SMTP
 Server (TLS) id 15.0.1347.2; Wed, 15 Jan 2020 10:21:45 +0000
Received: from AcuMS.Aculab.com ([fe80::43c:695e:880f:8750]) by
 AcuMS.aculab.com ([fe80::43c:695e:880f:8750%12]) with mapi id 15.00.1347.000;
 Wed, 15 Jan 2020 10:21:45 +0000
From:   David Laight <David.Laight@ACULAB.COM>
To:     "'ira.weiny@intel.com'" <ira.weiny@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC:     Alexander Viro <viro@zeniv.linux.org.uk>,
        "Darrick J. Wong" <darrick.wong@oracle.com>,
        Dan Williams <dan.j.williams@intel.com>,
        "Dave Chinner" <david@fromorbit.com>,
        Christoph Hellwig <hch@lst.de>,
        "Theodore Y. Ts'o" <tytso@mit.edu>, Jan Kara <jack@suse.cz>,
        "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>,
        "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>
Subject: RE: [RFC PATCH V2 09/12] fs: Prevent mode change if file is mmap'ed
Thread-Topic: [RFC PATCH V2 09/12] fs: Prevent mode change if file is mmap'ed
Thread-Index: AQHVx+xw3fI16+EnrkucPW5Ge+vrG6frihyw
Date:   Wed, 15 Jan 2020 10:21:45 +0000
Message-ID: <06258747f6824a35adfaa999ab4c2261@AcuMS.aculab.com>
References: <20200110192942.25021-1-ira.weiny@intel.com>
 <20200110192942.25021-10-ira.weiny@intel.com>
In-Reply-To: <20200110192942.25021-10-ira.weiny@intel.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-transport-fromentityheader: Hosted
x-originating-ip: [10.202.205.107]
MIME-Version: 1.0
X-MC-Unique: 1qiFO4UbN9aTPeO6iSwoTA-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From ira.weiny@intel.com
> Sent: 10 January 2020 19:30
> 
> Page faults need to ensure the inode mode is correct and consistent with
> the vmf information at the time of the fault.  There is no easy way to
> ensure the vmf information is correct if a mode change is in progress.
> Furthermore, there is no good use case to require a mode change while
> the file is mmap'ed.
> 
> Track mmap's of the file and fail the mode change if the file is
> mmap'ed.

This seems wrong to me.
I presume the 'mode changes' are from things like 'chmod -w ...'.
mmap() should be no different to open().
Only the permissions set when the file is opened count.

Next you'll be stopping unlink() when a file is open :-)

	David

-
Registered Address Lakeside, Bramley Road, Mount Farm, Milton Keynes, MK1 1PT, UK
Registration No: 1397386 (Wales)

