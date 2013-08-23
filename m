Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 8D6C629DFB
	for <xfs@oss.sgi.com>; Fri, 23 Aug 2013 08:34:12 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 7B0908F8033
	for <xfs@oss.sgi.com>; Fri, 23 Aug 2013 06:34:12 -0700 (PDT)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id YjGIOj3mCHXQanip for <xfs@oss.sgi.com>;
	Fri, 23 Aug 2013 06:34:11 -0700 (PDT)
References: <20130822213148.224998379@sgi.com> <52169488.2040303@sandeen.net>
	<521762F4.4050603@sgi.com>
Mime-Version: 1.0 (1.0)
In-Reply-To: <521762F4.4050603@sgi.com>
Message-Id: <08C24AC4-BA56-41C5-BC5C-0DBE2A5C1033@sandeen.net>
From: Eric Sandeen <sandeen@sandeen.net>
Subject: Re: [PATCH] xfs_io: v7 add the lseek() SEEK_DATA/SEEK_HOLE support
Date: Fri, 23 Aug 2013 08:34:08 -0500
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
To: Mark Tinguely <tinguely@sgi.com>
Cc: Rich Johnston <rjohnston@sgi.com>, "xfs@oss.sgi.com" <xfs@oss.sgi.com>

On Aug 23, 2013, at 8:26 AM, Mark Tinguely <tinguely@sgi.com> wrote:

> On 08/22/13 17:45, Eric Sandeen wrote:
>> On 8/22/13 4:31 PM, Mark Tinguely wrote:
>> 
>>> Add the lseek SEEK_DATA/SEEK_HOLE support into xfs_io.
>>> The result from the lseek() call will be printed to the output.
>>> For example:
>>> 
>>> xfs_io>  seek -h 609k
>>> HOLE    630784
>>> 
>>> Signed-off-by: Mark Tinguely<tinguely@sgi.com>
>>> ---
>>>  version 7 or 8 - Eric what number is this?
>> 
>> Go for 13, for luck!
>> 
>> I think this looks ok, I won't torture you any longer.  If there's anything
>> to fix up when it really gets used in earnest we can do it then.
>> 
>> (it crossed my mind that for the "-r" and "-a" invocations it might be good to print
>> out the offset which was sent for each SEEK_* "whence," but *shrug*)
>> 
>> Thanks for all the iterations,
>> 
>> Reviewed-by: Eric Sandeen<sandeen@redhat.com>
> 
> Rich, hold off on commit, I can quickly add the whence. We can see how she sails.
> 
Was just an idle thought... See if it makes sense I guess...

Thanks,
Eric

> --Mark
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs
> 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
