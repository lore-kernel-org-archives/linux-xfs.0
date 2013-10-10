Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 281BB7F51
	for <xfs@oss.sgi.com>; Wed,  9 Oct 2013 22:24:24 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 05FEB304048
	for <xfs@oss.sgi.com>; Wed,  9 Oct 2013 20:24:23 -0700 (PDT)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id DOEA9VVU127qTZga for <xfs@oss.sgi.com>;
	Wed, 09 Oct 2013 20:24:23 -0700 (PDT)
References: <4F75C939.6030009@redhat.com> <4F75CAD9.60808@redhat.com>
	<52561AE1.8010902@sandeen.net> <20131010032144.GV4446@dastard>
Mime-Version: 1.0 (1.0)
In-Reply-To: <20131010032144.GV4446@dastard>
Message-Id: <A336563C-E793-4A0B-AC01-53C685731A32@sandeen.net>
From: Eric Sandeen <sandeen@sandeen.net>
Subject: Re: [PATCH 2/2] xfs_fsr: create extent-based attr to grow forkoff
Date: Wed, 9 Oct 2013 22:24:19 -0500
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Dave Chinner <david@fromorbit.com>
Cc: Eric Sandeen <sandeen@redhat.com>, xfs-oss <xfs@oss.sgi.com>

On Oct 9, 2013, at 10:21 PM, Dave Chinner <david@fromorbit.com> wrote:
> 
>> On Wed, Oct 09, 2013 at 10:11:29PM -0500, Eric Sandeen wrote:
>>> On 3/30/12 10:01 AM, Eric Sandeen wrote:
>>> In some cases the target file may have a non-local attribute,
>>> but the temp file gets assigned a local attribute on creation,
>>> due to selinux, for example.
>>> 
>>> In this case, the large-ish selinux attr will create a forkoff
>>> in the temp file smaller than the forkoff in the target file,
>>> because the FMT_EXTENTS attr takes up less space.  There is
>>> no mechanism to grow the forkoff to match, so we can end up
>>> failing to swap these 2 inodes if the result is not enough
>>> data space in the temp inode as a result.
>>> 
>>> After testing the target file for a non-local extent, and
>>> checking to see if the forkoff needs to be grown on the first
>>> pass, we can add a large attr to knock all attributes of the
>>> temp file out of local format, and grow the fork offset.
>>> 
>>> This passes xfstest 227, and also resolves issues seen on
>>> a metadata image provided by Gabriel.
>>> 
>>> Reported-by: Gabriel VLASIU <gabriel@vlasiu.net>
>>> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
>>> ---
>> 
>> Ping #2?  This was a real bug once, IIRC.  Probably still is...
>> 
>> Patch 1/2 helped identify the problem, so ping on that too I guess.
> 
> Can you repost all these old patches as a new series to make it easy
> to apply and test them?
> 

Ok, good idea.

Eric

> Cheers,
> 
> Dave.
> -- 
> Dave Chinner
> david@fromorbit.com
> 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
