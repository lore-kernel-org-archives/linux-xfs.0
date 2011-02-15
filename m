Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p1F1wi1D170595 for <xfs@oss.sgi.com>; Mon, 14 Feb 2011 19:58:44 -0600
Received: from cpoproxy3-pub.bluehost.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with SMTP id 8ACB81DD0417
	for <xfs@oss.sgi.com>; Mon, 14 Feb 2011 18:01:21 -0800 (PST)
Received: from cpoproxy3-pub.bluehost.com (cpoproxy3-pub.bluehost.com
	[67.222.54.6]) by cuda.sgi.com with SMTP id SpG9XcpemCtDlxbV
	for <xfs@oss.sgi.com>; Mon, 14 Feb 2011 18:01:21 -0800 (PST)
Message-ID: <4D59DE68.2030201@tao.ma>
Date: Tue, 15 Feb 2011 10:01:12 +0800
From: Tao Ma <tm@tao.ma>
MIME-Version: 1.0
Subject: Re: XFS status update for January 2011
References: <20110213184219.GA22792@infradead.org> <4D5890B6.2090105@tao.ma>
	<20110214120237.GB13052@dastard>
	<04650f485d5814ddfe6893a3a7c8429b.squirrel@box585.bluehost.com>
	<20110214235517.GC13052@dastard>
In-Reply-To: <20110214235517.GC13052@dastard>
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
Cc: Christoph Hellwig <hch@infradead.org>, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, xfs@oss.sgi.com

On 02/15/2011 07:55 AM, Dave Chinner wrote:
> On Mon, Feb 14, 2011 at 08:20:18AM -0700, tm@tao.ma wrote:
>    
>> Hi Dave,
>>      
>>> On Mon, Feb 14, 2011 at 10:17:26AM +0800, Tao Ma wrote:
>>>        
>>>> Hi Christoph,
>>>> On 02/14/2011 02:42 AM, Christoph Hellwig wrote:
>>>>          
>>>>> On the 4th of January we saw the release of Linux 2.6.37, which
>>>>>            
>>>> contains a
>>>>          
>>>>> large XFS update:
>>>>>
>>>>>      67 files changed, 1424 insertions(+), 1524 deletions(-)
>>>>>
>>>>> User visible changes are the new XFS_IOC_ZERO_RANGE ioctl which allows
>>>>> to convert already allocated space into unwritten extents that return
>>>>> zeros on a read,
>>>>>            
>>>> would you mind describing some scenario that this ioctl can be used. I
>>>> am
>>>> just wondering whether ocfs2 can implement it as well.
>>>>          
>>> Zeroing a file without doing IO or having to punch out the blocks
>>> already allocated to the file.
>>>
>>> In this case, we had a couple of different people in cloud storage
>>> land asking for such functionality to optimise record deletion
>>> be avoiding disruption of their preallocated file layouts as a
>>> punch-then-preallocate operation does.
>>>        
>> Thanks for the info. yeah, ocfs2 is also used to host images in some cloud
>> computing environment. So It looks helpful for us too.
>>      
> Just to be clear, this optimisation isn't relevant for hosting VM
> images in a cloud compute environment - this was added for
> optimising the back end of distributed storage applications that
> hold tens of millions of records and tens of TB of data per back end
> storage host.
>
> Hosting VM images is largely static, especially if you are
> preallocating them - they never, ever get punched. Even if you are
> using thin provisioning semantics and punching TRIMmed ranges, you
> aren't converting the TRIMmed ranges back to preallocated state so
> you wouldn't be using this interface. Hence I don't see this as
> something that you would use in such an environment.
>
> The distributed storage applications that this was added for
> required atomic record deletes from the back end and the fastest and
> safest way to do that was to turn the record being deleted back into
> unwritten extents.  This allows that operation to be done atomically
> by the filesystem whilst providing simple recovery semantics to the
> application. The XFS_IOC_ZERO_RANGE ioctl simply prevents the
> fragmentation that this punch-then-preallocate operation was causing
> and allows the back end to scale to much larger record stores...
>    
aha, got it. thanks for the detailed explanation.

Regards,
Tao

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
