Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q8EGHTOm143573 for <xfs@oss.sgi.com>; Fri, 14 Sep 2012 11:17:29 -0500
Message-ID: <505358CD.4060609@sgi.com>
Date: Fri, 14 Sep 2012 11:18:21 -0500
From: Mark Tinguely <tinguely@sgi.com>
MIME-Version: 1.0
Subject: Re: [PATCH 020/102] xfs: warn if direct reclaim tries to writeback
	pages
References: <1345698180-13612-1-git-send-email-david@fromorbit.com>
	<1345698180-13612-21-git-send-email-david@fromorbit.com>
	<20120827181742.GA13970@infradead.org>
	<20120905113242.GL11266@suse.de> <50523E20.5000508@sgi.com>
	<20120914094523.GD11266@suse.de> <50532979.2070002@sgi.com>
In-Reply-To: <50532979.2070002@sgi.com>
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
To: Mel Gorman <mgorman@suse.de>
Cc: Christoph Hellwig <hch@infradead.org>, Dave Chinner <dchinner@redhat.com>, xfs@oss.sgi.com

On 09/14/12 07:56, Mark Tinguely wrote:
> On 09/14/12 04:45, Mel Gorman wrote:
>> On Thu, Sep 13, 2012 at 03:12:16PM -0500, Mark Tinguely wrote:

>>> WARNING: at fs/xfs/linux-2.6/xfs_aops.c:961
>>> xfs_vm_writepage+0x63c/0x6a0()
>>> Hardware name: S2721-533 Thunder i7501 Pro
>>> Modules linked in: ext4 jbd2 crc16
>>> Pid: 12122, comm: cp Not tainted 3.0.42 #2
>>
>> I ask because on 3.0.42 this warning is not present. This patch should
>> not be merged to 3.0-stable.
>>
>
> Correct. Linux-3.0.42 with Dave 102 patches, I removed patch 94 and 95
> per list comments. I added Brian Foster's patch as 103 <below>
>
> I am testing xfstest 109 and 273 in a loop for shutdown worker races -
> none found yet. That message happened in the first loop, and never
> occurred again.
>
> And the machine was a x86_32 not 64.

PS. of course it reports only once... that is what the patch does.
     reboot the machine and it displays on first call to test 273.

  Does not happen on the x86_64 machine. Until I can duplicate it on
  another x86_32, less us assume there is something weird with that
  machine.

--Mark.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
