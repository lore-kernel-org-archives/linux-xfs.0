Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 4E7A07F53
	for <xfs@oss.sgi.com>; Mon,  1 Jul 2013 07:17:14 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id D0419AC008
	for <xfs@oss.sgi.com>; Mon,  1 Jul 2013 05:17:10 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id 3C2FZOgs7lBtBEVl for
	<xfs@oss.sgi.com>; Mon, 01 Jul 2013 05:17:09 -0700 (PDT)
Message-ID: <51D17457.7090001@redhat.com>
Date: Mon, 01 Jul 2013 08:21:43 -0400
From: Brian Foster <bfoster@redhat.com>
MIME-Version: 1.0
Subject: Re: [PATCH 6/6] ioctl eofblocks: require non-privileged users to
	specify uid/gid match
References: <20130619110948.0bfafa2b@oracle.com>
	<20130620001341.GM29338@dastard>
	<20130620095410.1917d235@oracle.com>
	<20130620220311.GT29376@dastard>
	<20130621111420.5592707e@oracle.com>
	<20130624003316.GH29376@dastard>
	<20130624091035.6274800f@oracle.com>
	<20130626020924.GD29376@dastard>
	<20130628111138.68d0b486@oracle.com> <51CDDAF0.7060501@redhat.com>
	<20130628162825.4fb7e4ed@oracle.com> <51CE0281.4040403@redhat.com>
	<20130628192238.7d8bc38c@oracle.com>
In-Reply-To: <20130628192238.7d8bc38c@oracle.com>
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
To: Dwight Engen <dwight.engen@oracle.com>
Cc: "Eric W. Biederman" <ebiederm@gmail.com>, Serge Hallyn <serge.hallyn@ubuntu.com>, xfs@oss.sgi.com

On 06/28/2013 07:22 PM, Dwight Engen wrote:
> On Fri, 28 Jun 2013 17:39:13 -0400
> Brian Foster <bfoster@redhat.com> wrote:
> 
>> On 06/28/2013 04:28 PM, Dwight Engen wrote:
>>> On Fri, 28 Jun 2013 14:50:24 -0400
>>> Brian Foster <bfoster@redhat.com> wrote:
>>>
>>>> On 06/28/2013 11:11 AM, Dwight Engen wrote:
...
>>
>> To be honest, there aren't any real users of the eofblocks command
>> from userspace that I'm aware of at the moment. I added it originally
>> for a poc quota implementation I was working on for gluster, but the
>> primary use case for the scanning mechanism is to allow background
>> clean up of files such that post-eof speculative preallocation
>> doesn't hang around for too long.
> 
> ... and there are likely to be scenarios where waiting for the timer
> would be too long?
>  

Well one can adjust the timer via the /proc file if necessary. Our use
case was along the lines of ensuring prealloc was cleared up at certain
points where we wanted to track space usage (using a cluster of XFS
project quotas to represent a higher level quota), iirc. It's been a
while since I've looked at that code... ;)

>>> Maybe this permission stuff should be a separate change since it
>>> isn't really related to user namespace stuff? I just happened to be
>>> in the vicinity and am happy to help :)
>>>
>>
>> Sounds reasonable to me. :)
> 
> If you want me to code up either option, let me know.
>  

Feel free to. :) I agree that it's separate from the userns work.
I'll put it on my todo list if you don't get around to it.

Brian

>> Brian

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
