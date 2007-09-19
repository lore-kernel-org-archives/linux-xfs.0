Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 19 Sep 2007 13:44:01 -0700 (PDT)
Received: from postoffice.aconex.com (mail.app.aconex.com [203.89.192.138])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l8JKhuuw010171
	for <xfs@oss.sgi.com>; Wed, 19 Sep 2007 13:43:58 -0700
Message-ID: <54685.192.168.3.1.1190234658.squirrel@mail.aconex.com>
In-Reply-To: <20070919202239.GA32475@lst.de>
References: <20070919161202.GA18130@lst.de> <46F16752.1090702@sandeen.net>
    <20070919202239.GA32475@lst.de>
Date: Thu, 20 Sep 2007 06:44:18 +1000 (EST)
Subject: Re: [PATCH] kill XFS_INOBT_IS_FREE_DISK
From: nscott@aconex.com
MIME-Version: 1.0
Content-Type: text/plain;charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Christoph Hellwig <hch@lst.de>
Cc: Eric Sandeen <sandeen@sandeen.net>, xfs@oss.sgi.com

> On Wed, Sep 19, 2007 at 01:15:46PM -0500, Eric Sandeen wrote:
>> Christoph Hellwig wrote:
>> ...
>> XFS_SBF_NOFLAGS
>> XFS_SB_VERSION2_REALFBITS
>> XFS_SB_VERSION2_RESERVED1BIT
>> XFS_SB_VERSION2_RESERVED4BIT
>> XFS_SB_VERSION_ADDDALIGN
>> XFS_SB_VERSION_ADDEXTFLGBIT
>> XFS_SB_VERSION_ADDSHARED
>> XFS_SB_VERSION_SUBEXTFLGBIT
>> XFS_SB_VERSION_SUBSHARED
>
> I suspect there are kind expected to be unused.
>

They're used in userspace IIRC.  (Well, some - probably not the RESERVED
ones)

cheers.

--
Nathan
