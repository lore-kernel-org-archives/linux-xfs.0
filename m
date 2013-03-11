Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 196397F3F
	for <xfs@oss.sgi.com>; Mon, 11 Mar 2013 07:20:19 -0500 (CDT)
Message-ID: <513DCC13.6050800@sgi.com>
Date: Mon, 11 Mar 2013 07:20:35 -0500
From: Rich Johnston <rjohnston@sgi.com>
MIME-Version: 1.0
Subject: Re: [PATCH V2] xfs_repair: skip freelist scan of corrupt agf in
	no-modify mode
References: <51313DE8.5080104@sandeen.net> <51326DC0.8030403@sandeen.net>
	<513A4A9B.3050802@sgi.com> <20130309090041.GG23616@dastard>
In-Reply-To: <20130309090041.GG23616@dastard>
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
To: Dave Chinner <david@fromorbit.com>
Cc: xfs-oss <xfs@oss.sgi.com>, Eric Sandeen <sandeen@sandeen.net>, Ole Tange <tange@binf.ku.dk>

On 03/09/2013 03:00 AM, Dave Chinner wrote:
> On Fri, Mar 08, 2013 at 02:31:23PM -0600, Rich Johnston wrote:
>> This version looks good. ;)
>>
>> Reviewed-by: Rich Johnston <rjohnston@sgi.com>
>>
>> This has been committed.
>
> Except that all review comments have not been addressed. i.e there
> are two places that have the same bug and they haven't been fixed.
>
> It's great that you want to commit quickly, but commits should not
> happen while there are unaddressed issues still outstanding....

Sorry Dave I misunderstood your comments.  I took them to mean you were 
going to make those changes with your CRC patch. I will make sure to 
clarify before committing.

>
> Cheers,
>
> Dave.
>


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
