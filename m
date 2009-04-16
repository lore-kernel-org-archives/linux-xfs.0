Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n3HEcB6r141516 for <xfs@oss.sgi.com>; Fri, 17 Apr 2009 09:38:22 -0500
Received: from estes.americas.sgi.com (estes.americas.sgi.com [128.162.236.10])
	by relay1.corp.sgi.com (Postfix) with ESMTP id A70058F80E7
	for <xfs@oss.sgi.com>; Fri, 17 Apr 2009 07:37:56 -0700 (PDT)
Message-Id: <38A1E278-0C68-4301-A68D-C326E945399B@sgi.com>
From: Felix Blyakher <felixb@sgi.com>
In-Reply-To: <49E77ACA.9060301@tlinx.org>
Mime-Version: 1.0 (Apple Message framework v926)
Subject: Re: getting changes (fixes or enhancements) to xfs-tools
Date: Thu, 16 Apr 2009 16:15:35 -0500
References: <49E65044.8080802@tlinx.org> <49E6B6F7.6030500@sandeen.net>
	<49E6ED88.5020008@tlinx.org> <49E746A0.5020008@sandeen.net>
	<49E77ACA.9060301@tlinx.org>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"; DelSp="yes"
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: "Linda A. Walsh" <xfs@tlinx.org>
Cc: xfs-oss <xfs@oss.sgi.com>


On Apr 16, 2009, at 1:36 PM, Linda A. Walsh wrote:

> Eric Sandeen wrote:
>> Linda A. Walsh wrote:
>>> I can understand that for kernel work, but what about the xfs utils?
>> Again, just look at the git logs.
>> -Eric
> ----
>
>   I understand you want people to see the work that has gone into the
> kernel, but telling someone to search through 1327 entries just to  
> find
> an answer of 'no', seems a bit ...something.

Eric responded about xfs utilities, which are not in the kernel.

>    FWIW: I copied all 1327 entries to a text file and searched for
> any string "xfs[a-z]" to search for any comments about utility  
> changes.
> Only strings found were for the daemons that are run.

Wrong log.

>    Now that I've determined that the xfs utils are not in the kernel
> source tree (I wouldn't have expected them to be), maybe I can more
> be less indirect and ask: Who is managing the the xfs_utils,

Me, as well as Christoph in a (cloned) kernel.org tree.

> Where are
> they kept and

on oss as tarballs:

ftp://oss.sgi.com/projects/xfs/cmd_tars/xfsprogs-3.0.0.tar.gz
ftp://oss.sgi.com/projects/xfs/cmd_tars/xfsdump-3.0.0.tar.gz

The tarballs release announcement was posted to this list.

Or in the git repositories on oss:

git://oss.sgi.com/xfs/cmds/xfsprogs.git
git://oss.sgi.com/xfs/cmds/xfsdump.git

and kernel.org:

git://git.kernel.org/pub/scm/fs/xfs/xfsprogs-dev.git
git://git.kernel.org/pub/scm/fs/xfs/xfsdump-dev.git


> What is the procedure for trying to get changes (fixes
> or enhancements) to them?   (I prefer direct questioning, but too many
> people, even in the engineering/sw community,  find it rude or abrupt,
> so it's not usually my 1st choice).
>
> In other words, does one:
>
> (I) suggest new ideas and if the keeper(s) likes them, they are
>    implemented and redistributed?

You mean implemented by maintainer? Others?
Sure, they well may be, but it would depend on priorities.

>  OR
> (II.1) suggest new ideas and see if keeper(s) approve of 'project' so

Yes, it prudent to get the nod from others about goodness
of the idea before implementing it.

>    one can then go and
>    (i) implement the changes in a local version, and then?
>    	(a) check them in?

into your local tree ...

>
>          OR
>        (b) submit for approval so they can be approved for
>            inclusion (or fixing any found problems)

That would be the right way to get it into the tree.
See Documentation/SubmittingPatches. The idea applies to
patches in the userland as well. Actually, we treat
utilities exactly the same way as the kernel xfs.

>  OR
> (III) just go off and implement the code, then come back and say, hey,
>    here are my changes for this idea, and just expect to be greeted
>    with open arms?  ;^/

That may well be the case. But it also could be just the opposite.
So, it's prudent to check the idea first.

> ---
> (I hope I got the indentation and syntax correct in that, English
> syntax isn't always the easiest language to express nested options
> in...:-))
>
>    I'm trying to get clear on process.  If they are in the kernel
> tree, there may be no way for me to get from A->B, othewise, I'm
> trying to find out where one might have hope of bouncing ideas

I guess, you're already aware about the xfs mailing list.
Post them there.

Hope that helps.
Felix

> that
> might get implemented or that if sufficiently positively received
> might spure someone to try implementing the changes themselves (and
> possibly (and possibly get in completely over their head....or not.)
>
> :-)
> thanks!
> -linda
>
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
