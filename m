Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 1006C7F3F
	for <linux-xfs@oss.sgi.com>; Wed, 16 Oct 2013 12:35:43 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 040CC304043
	for <linux-xfs@oss.sgi.com>; Wed, 16 Oct 2013 10:35:39 -0700 (PDT)
Received: from plane.gmane.org (plane.gmane.org [80.91.229.3]) by cuda.sgi.com
	with ESMTP id tXsugdmpjSQHDcsM (version=TLSv1 cipher=AES256-SHA
	bits=256 verify=NO) for <linux-xfs@oss.sgi.com>;
	Wed, 16 Oct 2013 10:35:38 -0700 (PDT)
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <sgi-linux-xfs@m.gmane.org>) id 1VWV0S-00059e-AI
	for linux-xfs@oss.sgi.com; Wed, 16 Oct 2013 19:35:36 +0200
Received: from wombat.san-francisco.ca.us ([75.101.60.140])
	by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
	id 1AlnuQ-0007hv-00
	for <linux-xfs@oss.sgi.com>; Wed, 16 Oct 2013 19:35:36 +0200
Received: from kkeller by wombat.san-francisco.ca.us with local (Gmexim 0.1
	(Debian)) id 1AlnuQ-0007hv-00
	for <linux-xfs@oss.sgi.com>; Wed, 16 Oct 2013 19:35:36 +0200
From: Keith Keller <kkeller@wombat.san-francisco.ca.us>
Subject: Re: xfs corrupted
Date: Wed, 16 Oct 2013 10:33:06 -0700
Message-ID: <i7v2jax9rs.ln2@goaway.wombat.san-francisco.ca.us>
References: <1381826507281-35009.post@n7.nabble.com>
	<20131015203434.2f336fd8@galadriel.home>
	<525D8D67.2090301@keptprivate.com>
	<20131015213447.40d05ea0@galadriel.home>
	<525D9E3B.5040507@keptprivate.com>
	<20131015202640.GR4446@dastard> <525E9550.80008@keptprivate.com>
Mime-Version: 1.0
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
To: linux-xfs@oss.sgi.com

On 2013-10-16, Stefanita Rares Dumitrescu <katmai@keptprivate.com> wrote:
>
> The xfsprogs from the centos6 yum are newer

They are certainly newer than from CentOS 5, but are still reasonably
old compared to git.  You should probably prefer the latest stable
version or the git version over what's available from yum by default.

> I cloned the xfsprogs git and i am running it now with the new 15 gb 
> swap that i created, and this is a monster in memory usage.
>
> Pretty bit of discrepancy.

As others have suggested, lots of memory use is to be expected with the
size of the filesystem and the amount of memory you have.  Did you use
the -P switch as Dave suggested?  I have found it very helpful in
low-memory situations.

--keith

-- 
kkeller@wombat.san-francisco.ca.us


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
