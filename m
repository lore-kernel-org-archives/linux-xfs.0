Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n3GKpTEn091016 for <xfs@oss.sgi.com>; Thu, 16 Apr 2009 15:51:39 -0500
Received: from mx2.redhat.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 6738514294DD
	for <xfs@oss.sgi.com>; Thu, 16 Apr 2009 13:53:07 -0700 (PDT)
Received: from mx2.redhat.com (mx2.redhat.com [66.187.237.31]) by cuda.sgi.com
	with ESMTP id Sr7HmyJd2JCvDCPt for <xfs@oss.sgi.com>;
	Thu, 16 Apr 2009 13:53:07 -0700 (PDT)
Message-ID: <49E79A28.2070302@sandeen.net>
Date: Thu, 16 Apr 2009 15:50:48 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: getting changes (fixes or enhancements) to xfs-tools
References: <49E65044.8080802@tlinx.org>
	<49E6B6F7.6030500@sandeen.net>	<49E6ED88.5020008@tlinx.org>
	<49E746A0.5020008@sandeen.net> <49E77ACA.9060301@tlinx.org>
In-Reply-To: <49E77ACA.9060301@tlinx.org>
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
To: "Linda A. Walsh" <xfs@tlinx.org>
Cc: xfs-oss <xfs@oss.sgi.com>

Linda A. Walsh wrote:
> Eric Sandeen wrote:
>> Linda A. Walsh wrote:
>>> I can understand that for kernel work, but what about the xfs utils? 
>> Again, just look at the git logs.
>> -Eric
> ----
> 
>     I understand you want people to see the work that has gone into the
> kernel, but telling someone to search through 1327 entries just to find
> an answer of 'no', seems a bit ...something.

You originally asked, as far as I understood it, whether xfs can survive
if sgi does not.

I suggested that you read the list and look at the changelogs, and see
how much work is being done on xfs from -outside- sgi, as this may help
to answer your question.

>      FWIW: I copied all 1327 entries to a text file and searched for
> any string "xfs[a-z]" to search for any comments about utility changes.
> Only strings found were for the daemons that are run.
> 
>      Now that I've determined that the xfs utils are not in the kernel
> source tree (I wouldn't have expected them to be), maybe I can more
> be less indirect and ask: Who is managing the the xfs_utils, Where are
> they kept and What is the procedure for trying to get changes (fixes
> or enhancements) to them?   (I prefer direct questioning, but too many
> people, even in the engineering/sw community,  find it rude or abrupt,
> so it's not usually my 1st choice).

Changes happen as they always have; patches are sent to the xfs
development mailing list.  There are git trees on kernel.org as well as
on oss.sgi.com, though I'm not sure the exact details matter too
terribly much here.  It all ultimately, eventually flows to a tarball on
oss.sgi.com.

http://oss.sgi.com/cgi-bin/gitweb.cgi?p=xfs/xfs.git;a=summary
http://oss.sgi.com/cgi-bin/gitweb.cgi?p=xfs/cmds/xfsprogs.git;a=summary
http://oss.sgi.com/cgi-bin/gitweb.cgi?p=xfs/cmds/xfsdump.git;a=summary
http://oss.sgi.com/cgi-bin/gitweb.cgi?p=xfs/cmds/dmapi.git;a=summary
http://oss.sgi.com/cgi-bin/gitweb.cgi?p=xfs/cmds/xfstests.git;a=summary

http://git.kernel.org/?p=fs/xfs/xfs.git;a=summary
http://git.kernel.org/?p=fs/xfs/xfsprogs-dev.git;a=summary
http://git.kernel.org/?p=fs/xfs/xfsdump-dev.git;a=summary
http://git.kernel.org/?p=fs/xfs/dmapi-dev.git;a=summary
http://git.kernel.org/?p=fs/xfs/xfstests-dev.git;a=summary

ftp://oss.sgi.com/projects/xfs/cmd_tars/

> In other words, does one:
> 
> (I) suggest new ideas and if the keeper(s) likes them, they are
>      implemented and redistributed?

You could try that, though there is always the resource issue.  Many
people are full of good ideas; fewer people can implement them :)

> (II.1) suggest new ideas and see if keeper(s) approve of 'project' so
>      one can then go and
>      (i) implement the changes in a local version, and then?
>      	(a) check them in?

no, you can't check them in upstream, the maintainers do that ...

>            OR
>          (b) submit for approval so they can be approved for
>              inclusion (or fixing any found problems)

yes, send them to the list as has always been done.

> (III) just go off and implement the code, then come back and say, hey,
>      here are my changes for this idea, and just expect to be greeted
>      with open arms?  ;^/

subject to review of course.  It'd always be better to float the plan on
the list first before you go off and do a bunch of work.

> ---
> (I hope I got the indentation and syntax correct in that, English
> syntax isn't always the easiest language to express nested options
> in...:-))
> 
>      I'm trying to get clear on process.  If they are in the kernel
> tree, there may be no way for me to get from A->B, othewise, I'm
> trying to find out where one might have hope of bouncing ideas that
> might get implemented or that if sufficiently positively received
> might spure someone to try implementing the changes themselves (and
> possibly (and possibly get in completely over their head....or not.)

Basically, everything starts on the list, and ends in the git trees or
tarballs.  This will continue to be true even if, for any reason, sgi
were to disappear, we'd just have potentially new URLs and fewer resources.

-Eric

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
