Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p7UHjglI149559 for <xfs@oss.sgi.com>; Tue, 30 Aug 2011 12:45:42 -0500
Received: from rcsinet15.oracle.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 68B10126DC4
	for <xfs@oss.sgi.com>; Tue, 30 Aug 2011 10:45:40 -0700 (PDT)
Received: from rcsinet15.oracle.com (rcsinet15.oracle.com [148.87.113.117]) by
	cuda.sgi.com with ESMTP id EmQNhHaJUAfQdU0T for
	<xfs@oss.sgi.com>; Tue, 30 Aug 2011 10:45:40 -0700 (PDT)
Message-ID: <4E5D210D.3040608@oracle.com>
Date: Tue, 30 Aug 2011 10:42:37 -0700
From: Sunil Mushran <sunil.mushran@oracle.com>
MIME-Version: 1.0
Subject: Re: [PATCH] xfstests 255: add a seek_data/seek_hole tester
References: <1309275199-10801-1-git-send-email-josef@redhat.com>
	<1309275199-10801-5-git-send-email-josef@redhat.com>
	<20110825060632.GA9933@infradead.org>
	<20110825064039.GO3162@dastard>
	<0A267E55-7772-438D-B6A7-89B73020F311@dilger.ca>
	<20110826013528.GW3162@dastard>
	<CANGUGtC1qk2Tkv42fvibUKiEJz_MnNiV-nQ7T-_woppVhjQK-Q@mail.gmail.com>
	<20110826144124.GA17519@lulu.zabbo.net>
	<4E58AB28.1080009@gmail.com>
In-Reply-To: <4E58AB28.1080009@gmail.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Marco Stornelli <marco.stornelli@gmail.com>
Cc: Andreas Dilger <adilger@dilger.ca>, linux-kernel@vger.kernel.org, xfs@oss.sgi.com, Christoph Hellwig <hch@infradead.org>, linux-btrfs@vger.kernel.org, dchinner@redhat.com, linux-fsdevel@vger.kernel.org, Zach Brown <zab@zabbo.net>, Josef Bacik <josef@redhat.com>, viro@zeniv.linux.org.uk

On 08/27/2011 01:30 AM, Marco Stornelli wrote:
> Il 26/08/2011 16:41, Zach Brown ha scritto:
>>>> Hole: a range of the file that contains no data or is made up
>>>> entirely of  NULL (zero) data. Holes include preallocated ranges of
>>>> files that have not had actual data written to them.
>>
>>> No for me. A hole is made up of zero data? It's a strange definition
>>> for me.
>>
>> It's a very natural definition for me.  It mirrors the behaviour of
>> read() of sparse data inside i_size that file system authors already
>> have to consider.
>>
>> It's also a reminder for people that this interface is about avoiding
>> reading zeros.  Systems that track contents can do this for files that
>> had tons of zeros written.  The data is there but the app is
>> specifically asking us to skip it by using SEEK_DATA.
>>
>> - z
>>
>
> I think we need to consider a hole and "data not present/not written yet" as two different cases even they are related. For example, if I do an fallocate without keep size option, then I do a read, I have the same behavior of sparse data inside i_size, but the blocks are allocated so no sparse data in this case. Simply there are no difference from app point of view.

Exactly. That's why seek_hole should identify them alike, if possible.
But that should not be a requirement because the sole aim here is
to improve performance. Identifying a hole as data is not the end of
the world. In some cases it may be more efficient. We just have to
ensure that we don't identify data as a hole.

BTW, we still have the fiemap interface that allows users to identify
unwritten extents, etc. Use that if you want that kind of detail.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
