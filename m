Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id B08517F7C
	for <xfs@oss.sgi.com>; Tue, 30 Sep 2014 22:05:01 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 5B827AC00A
	for <xfs@oss.sgi.com>; Tue, 30 Sep 2014 20:05:01 -0700 (PDT)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id 5thb7JkyvNnlo42x for <xfs@oss.sgi.com>;
	Tue, 30 Sep 2014 20:04:54 -0700 (PDT)
Message-ID: <542B6F55.3090409@sandeen.net>
Date: Tue, 30 Sep 2014 22:04:53 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: Happened again,
	20140930 -- Got "Internal error XFS_WANT_CORRUPTED_GOTO".
	Filesystem needs reformatting to correct issue.
References: <alpine.LSU.2.11.1407021104480.9881@Telcontar.valinor>	<alpine.LSU.2.11.1408111559280.2447@minas-tirith.valinor>	<alpine.LSU.2.11.1410010001350.17407@minas-tirith.valinor>	<20141001004514.GH24490@dastard>
	<542B6B8A.2060309@opensuse.org>
In-Reply-To: <542B6B8A.2060309@opensuse.org>
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
To: "Carlos E. R." <carlos.e.r@opensuse.org>, XFS mailing list <xfs@oss.sgi.com>

On 9/30/14 9:48 PM, Carlos E. R. wrote:
> On 2014-10-01 02:45, Dave Chinner wrote:
>> On Wed, Oct 01, 2014 at 12:27:20AM +0200, Carlos E. R. wrote:
> 
>> We've already got the fix in our upstream repository:
>>
>> 8018ec0 xfs: mark all internal workqueues as freezable
>>
>> It's currently in linux-next, queued for the next merge window. You
>> shoul dprobably talk to your distro about getting it backported.
> 
> Wow, thanks. I'll tell them.
> 
> Question: where does it apply, kernel, xfsprogs? They will know, but I don't, and I need that info for the bugzilla "component" field ;-)
> 

kernel

-Eric

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
