Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n194Wlw9219288 for <xfs@oss.sgi.com>; Sun, 8 Feb 2009 22:32:47 -0600
Message-ID: <498FB128.4060008@melbourne.sgi.com>
Date: Mon, 09 Feb 2009 15:29:28 +1100
From: Greg Banks <gnb@melbourne.sgi.com>
MIME-Version: 1.0
Subject: Re: [patch 2/5] [PATCH] acl: various improvements for test/run
References: <20090108015355.613058570@ifup.org>	<20090108015418.699729152@ifup.org>
	<200902090229.47550.agruen@suse.de>
In-Reply-To: <200902090229.47550.agruen@suse.de>
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Andreas Gruenbacher <agruen@suse.de>
Cc: tes@sgi.com, brandon@ifup.org, Brandon Philips <bphilips@suse.de>, xfs@oss.sgi.com

Andreas Gruenbacher wrote:
> Brandon,
>
> the version of the run script in the attr and acl packages is somewhat dated; 
> I have made a few improvements since. I'll move this out of {acl,attr}/test 
> and put the latest version into the libmisc/ directory.
>
> Note that I recently rewrote the run script from scratch. Unlike the old 
> version, the new one runs the whole script inside the same shell. There are 
> still a few problems to be solved; most importantly, user switching doesn't 
> work, yet.
I hope you get that feature done soon, and look forward to reviewing
it.  Let me just be Captain Obvious and say that user switching is a
critical feature for code used to drive ACL tests ;-)

>  Eventually I want to replace the old version, though.
>
> 	http://savannah.nongnu.org/projects/shrun
>
>
>
>   
>> Add a | test line that is similar to > but is interpreted as a regular
>> expression.
>>     
>
> I have been using ">~" instead of "|" for that. I'm still not sure that 
> including regular expression matching was a good idea though, so shrun 
> doesn't have any of that yet. We'll se how things develop.
>
>
>   
Regexp matching is the kind of thing that sounds like it could be quite
useful, but it's a pain to implement.  When I wrote a Python interpreter
for the shrun language for use in Newpynfs, I didn't bother implementing
the regexp feature.

-- 
Greg Banks, P.Engineer, SGI Australian Software Group.
the brightly coloured sporks of revolution.
I don't speak for SGI.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
