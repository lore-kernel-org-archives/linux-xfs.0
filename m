Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 5BA157F50
	for <xfs@oss.sgi.com>; Thu, 26 Sep 2013 10:26:58 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 2D6D68F8033
	for <xfs@oss.sgi.com>; Thu, 26 Sep 2013 08:26:54 -0700 (PDT)
Received: from benjamin.baylink.com (rrcs-24-129-180-187.se.biz.rr.com
	[24.129.180.187]) by cuda.sgi.com with ESMTP id
	6cNnzDtgg3yBSzoQ for <xfs@oss.sgi.com>;
	Thu, 26 Sep 2013 08:26:52 -0700 (PDT)
Received: from localhost (localhost.localdomain [127.0.0.1])
	by benjamin.baylink.com (Postfix) with ESMTP id 28A7F1F00173
	for <xfs@oss.sgi.com>; Thu, 26 Sep 2013 11:26:52 -0400 (EDT)
Received: from benjamin.baylink.com ([127.0.0.1])
	by localhost (benjamin.baylink.com [127.0.0.1]) (amavisd-new,
	port 10024) with ESMTP id ZrcV+WTp7ZLd for <xfs@oss.sgi.com>;
	Thu, 26 Sep 2013 11:26:47 -0400 (EDT)
Received: from benjamin.baylink.com (benjamin.baylink.com [192.168.253.10])
	by benjamin.baylink.com (Postfix) with ESMTP id B7CC51F002D2
	for <xfs@oss.sgi.com>; Thu, 26 Sep 2013 11:26:47 -0400 (EDT)
Date: Thu, 26 Sep 2013 11:26:47 -0400 (EDT)
From: Jay Ashworth <jra@baylink.com>
Message-ID: <20084214.8829.1380209207683.JavaMail.root@benjamin.baylink.com>
In-Reply-To: <52444BDD.9060100@gmail.com>
Subject: Re: Issues and new to the group
MIME-Version: 1.0
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
To: xfs@oss.sgi.com

----- Original Message -----
> From: "Joe Landman" <joe.landman@gmail.com>

> > takes. The folders are image folders that have anywhere between 5 to
> > 10 million images in each folder.
> 
> The combination of very large folders, and virtualization is working
> against you. Couple that with an old (ancient by Linux standards) xfs
> in the virtual CentOS 5.9 system, and you aren't going to have much
> joy with this without changing a few things.

> Can you change from one single large folder to a heirarchical set of
> folders? The single large folder means any metadata operation (ls,
> stat, open, close) has a huge set of lists to traverse. It will work,
> albiet slowly. As a rule of thumb, we try to make sure our users don't
> go much beyond 10k files/folder. If they need to, building a heirarchy
> of folders slightly increases management complexity, but keeps the
> lists that are needed to be traversed much smaller.
> 
> A strategy for doing this: If your files are named "aaaa0001"
> "aaaa0002" ... "zzzz9999" or similar, then you can chop off the first
> letter, and make a directory of it, and then put all files starting
> with that letter in that directory. Then within each of those directories,
> do the same thing with the second letter. This gets you 676
> directories and about 15k files per directory. Much faster directory operations.
> Much smaller lists to traverse.

While this problem isn't *near* as bad on XFS as it was on older filesystems,
where over maybe 500-1000 files would result in 'ls' commands taking
over a minute...

It's still a good idea to filename hash large collections of files of 
similar types into a directory tree, as Joe recommends.  The best approach
I myself have seen to this is to has a filename of

835bfak3f89yu12.jpg

into

8/3/5/b/835bfak3f89yu12.jpg
8/3/5/b/f/835bfak3f89yu12.jpg
8/3/5/b/f/a/835bfak3f89yu12.jpg

Going as deep as necessary to reduce the size of the directories. What
you lose in needing to cache the extra directory levels outweighs (probably
far outweighs) having to handle Directories Of Unusual Size.

Note that I didn't actually trim the filename proper; the final file still has
its full name.  This hash is easy to build, as long as you fix the number of layers
in advance... and if you need to make it deeper, later, it's easy to build a 
shell script that crawls the current tree and adds the next layer.

Cheers,
-- jra
-- 
Jay R. Ashworth                  Baylink                       jra@baylink.com
Designer                     The Things I Think                       RFC 2100
Ashworth & Associates     http://baylink.pitas.com         2000 Land Rover DII
St Petersburg FL USA               #natog                      +1 727 647 1274

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
