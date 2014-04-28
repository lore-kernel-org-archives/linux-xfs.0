Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 1D7FA29DF8
	for <xfs@oss.sgi.com>; Mon, 28 Apr 2014 12:22:16 -0500 (CDT)
Message-ID: <535E8E47.2040701@sgi.com>
Date: Mon, 28 Apr 2014 12:22:15 -0500
From: Mark Tinguely <tinguely@sgi.com>
MIME-Version: 1.0
Subject: Re: [PATCH] xfs: test for shut down fs in xfs_dir_fsync()
References: <535E8344.2070209@redhat.com>
	<20140428164754.GA17472@infradead.org>
	<535E8D67.3010504@redhat.com>
In-Reply-To: <535E8D67.3010504@redhat.com>
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Eric Sandeen <sandeen@redhat.com>
Cc: Christoph Hellwig <hch@infradead.org>, Boris Ranto <branto@redhat.com>, xfs-oss <xfs@oss.sgi.com>

On 04/28/14 12:18, Eric Sandeen wrote:
> On 4/28/14, 11:47 AM, Christoph Hellwig wrote:
>> On Mon, Apr 28, 2014 at 11:35:16AM -0500, Eric Sandeen wrote:
>>> Similar to xfs_file_fsync(), I think xfs_dir_fsync() needs
>>> to test for a shut down fs,
>>
>> It probably should.
>>
>>> lest we go down paths we'll
>>> never be able to complete; Boris reported that during some
>>> stress tests he had threads stuck in xlog_cil_force_lsn
>>> via xfs_dir_fsync().
>>
>> But this could still happen if we get a shutdown coming in after that
>> test.
>
> True... that looked a bit hairier to sort out.  :(
>
> -Eric
>


Are the sync lsn look okay? Was there an error writing the iclog buffer?

xfs_do_force_shutdown() will also do a xlog_cil_force_lsn() via the 
xfs_log_force_umount if the log buffer write was not in error. That 
should be the same or later than this lsn.

--Mark.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
