Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id DC5617F37
	for <xfs@oss.sgi.com>; Sun, 11 Aug 2013 21:54:49 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id C776D304032
	for <xfs@oss.sgi.com>; Sun, 11 Aug 2013 19:54:46 -0700 (PDT)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id wevAQOJWcJ29DFsB for <xfs@oss.sgi.com>;
	Sun, 11 Aug 2013 19:54:45 -0700 (PDT)
References: <1375949833-1104-1-git-send-email-list.xfs@jan-o-sch.net>
	<1375949833-1104-2-git-send-email-list.xfs@jan-o-sch.net>
	<5203D827.3050909@sandeen.net> <20130812011539.GM12779@dastard>
Mime-Version: 1.0 (1.0)
In-Reply-To: <20130812011539.GM12779@dastard>
Message-Id: <BB446B35-F3DA-462E-9E2C-9E4B780BC6B9@sandeen.net>
From: Eric Sandeen <sandeen@sandeen.net>
Subject: Re: [PATCH v3 1/2] xfstests: add fssum tool
Date: Sun, 11 Aug 2013 21:54:41 -0500
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
Cc: Jan Schmidt <list.xfs@jan-o-sch.net>, "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>, "sbehrens@giantdisaster.de" <sbehrens@giantdisaster.de>, "xfs@oss.sgi.com" <xfs@oss.sgi.com>

On Aug 11, 2013, at 8:15 PM, Dave Chinner <david@fromorbit.com> wrote:

> On Thu, Aug 08, 2013 at 12:40:55PM -0500, Eric Sandeen wrote:
>> On 8/8/13 3:17 AM, Jan Schmidt wrote:
>>> SUBDIRS =
>>> 
>>> LLDLIBS = $(LIBATTR) $(LIBHANDLE) $(LIBACL)
>>> 
>>> +OPT_LDLIBS = -lssl -lcrypto
>> 
>> Hm, new deps.  I guess it's not a huge problem, these should always
>> be available, right?
> 
> Please, let's keep crypto out of xfstests if we can. That's just
> going to add a nightmare of US export compliance garbage to any
> distro that wants to package and ship this....
> 
It's ssl that's (optionally) required for check summing I believe.  But it's optional if done properly...

-Eric

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
