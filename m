Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q0DKox3F160083 for <xfs@oss.sgi.com>; Fri, 13 Jan 2012 14:51:00 -0600
Received: from e31.co.us.ibm.com (e31.co.us.ibm.com [32.97.110.149]) by
	cuda.sgi.com with ESMTP id fhB6SKirgHcHB876 for
	<xfs@oss.sgi.com>; Fri, 13 Jan 2012 12:50:58 -0800 (PST)
Received: from /spool/local
	by e31.co.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only!
	Violators will be prosecuted
	for <xfs@oss.sgi.com> from <achender@linux.vnet.ibm.com>;
	Fri, 13 Jan 2012 13:50:58 -0700
Received: from d03av03.boulder.ibm.com (d03av03.boulder.ibm.com [9.17.195.169])
	by d03relay03.boulder.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id
	q0DKosoN158196 for <xfs@oss.sgi.com>; Fri, 13 Jan 2012 13:50:54 -0700
Received: from d03av03.boulder.ibm.com (loopback [127.0.0.1])
	by d03av03.boulder.ibm.com (8.14.4/8.13.1/NCO v10.0 AVout) with ESMTP
	id q0DKosBW019530
	for <xfs@oss.sgi.com>; Fri, 13 Jan 2012 13:50:54 -0700
Message-ID: <4F10992C.3070303@linux.vnet.ibm.com>
Date: Fri, 13 Jan 2012 13:50:52 -0700
From: Allison Henderson <achender@linux.vnet.ibm.com>
MIME-Version: 1.0
Subject: Re: working on extent locks for i_mutex
References: <4F0F9E97.1090403@linux.vnet.ibm.com>
	<20120113043411.GH2806@dastard>
In-Reply-To: <20120113043411.GH2806@dastard>
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
To: Dave Chinner <david@fromorbit.com>
Cc: Lukas Czerner <lczerner@redhat.com>, Ext4 Developers List <linux-ext4@vger.kernel.org>, xfs@oss.sgi.com

On 01/12/2012 09:34 PM, Dave Chinner wrote:
> On Thu, Jan 12, 2012 at 08:01:43PM -0700, Allison Henderson wrote:
>> Hi All,
>>
>> I know this is an old topic, but I am poking it again because I've
>> had some work items wrap up, and Im planning on picking up on this
>> one again.  I am thinking about implementing extent locks to replace
>> i_mutex.  So I just wanted to touch base with folks and see what
>> people are working on because I know there were some folks out there
>> that were thing about doing similar solutions.
>
> What locking API are you looking at? If you are looking at an
> something like:
>
> read_range_{try}lock(lock, off, len)
> read_range_unlock(lock, off, len)
> write_range_{try}lock(lock, off, len)
> write_range_unlock(lock, off, len)
>
> and implementing with an rbtree or a btree for tracking, then I
> definitely have a use for it in XFS - replacing the current rwsem
> that is used for the iolock. Range locks like this are the only
> thing we need to allow concurrent buffered writes to the same file
> to maintain the per-write exclusion that posix requires.
>
> Cheers,
>
> Dave.

Yes that is generally the idea I was thinking about doing, but at the 
time, I was not thinking outside the scope of ext4.  You are thinking 
maybe it should be in vfs layer so that it's something that all the 
filesystems will use?  That seems to be the impression I'm getting from 
folks.  Thx!

Allison Henderson

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
