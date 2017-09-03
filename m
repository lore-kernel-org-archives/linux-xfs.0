Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:37402 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1753031AbdICWEi (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 3 Sep 2017 18:04:38 -0400
From: Richard Wareing <rwareing@fb.com>
Subject: Re: [PATCH v2 3/3] fs/xfs: Add rtfallocmin mount option
Date: Sun, 3 Sep 2017 22:04:08 +0000
Message-ID: <88C6174E-9DF6-492F-9F19-DDB68687CCC2@fb.com>
References: <20170902224145.1291030-1-rwareing@fb.com>
 <20170902224145.1291030-4-rwareing@fb.com>
 <20170903085013.GE32385@infradead.org>
In-Reply-To: <20170903085013.GE32385@infradead.org>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-ID: <A56EF31D974DFA45B8DB226998F22011@namprd15.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@infradead.org>
Cc: "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>, "david@fromorbit.com" <david@fromorbit.com>, "darrick.wong@oracle.com" <darrick.wong@oracle.com>


> On Sep 3, 2017, at 1:50 AM, Christoph Hellwig <hch@infradead.org> wrote:
>=20
> On Sat, Sep 02, 2017 at 03:41:45PM -0700, Richard Wareing wrote:
>> - Gates real-time block device fallocation's to rtfallocmin bytes
>> - Use case: Allows developers to send files to the SSD with ease simply
>>  by fallocating them, if they are below rtfallocmin XFS will allocate th=
e
>>  blocks from the non-RT device (e.g. an SSD)
>> - Useful to automagically store small files on the SSD vs. RT device
>>  (HDD) for tiered XFS setups without having to rely on XFS specific
>>  ioctl calls.  Userland tools such as rsync can also use fallocation
>>  behavior to migrate files between SSD and RT (HDD) device without
>>  modifiction (e.g. w/ --preallocate flag).
>=20
> I'd be much happier if this was done inside the allocator, and in
> affect for any initial allocation, not just fallocate, as that keeps
> the layering and logic much cleaner.

See my comments on your reply to my cover letter.  Would love to hear your =
thoughts on my reply.

> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

