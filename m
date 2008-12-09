Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id
	mB9HXm0Q004975 for <xfs@oss.sgi.com>; Tue, 9 Dec 2008 11:33:51 -0600
Received: from slurp.thebarn.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 195C617012AD
	for <xfs@oss.sgi.com>; Tue,  9 Dec 2008 09:33:47 -0800 (PST)
Received: from slurp.thebarn.com (cattelan-host202.dsl.visi.com
	[208.42.117.202]) by cuda.sgi.com with ESMTP id
	2quH1f85kZp2Ia7S for <xfs@oss.sgi.com>;
	Tue, 09 Dec 2008 09:33:47 -0800 (PST)
Received: from funky.thebarn.com (slurp.thebarn.com [208.42.117.201])
	(authenticated bits=0)
	by slurp.thebarn.com (8.14.0/8.14.0) with ESMTP id mB9HCd2V065566;
	Tue, 9 Dec 2008 11:12:39 -0600 (CST) (envelope-from cattelan@xfs.org)
Message-ID: <493EA707.3000409@xfs.org>
Date: Tue, 09 Dec 2008 11:12:39 -0600
From: Russell Cattelan <cattelan@thebarn.com>
MIME-Version: 1.0
Subject: Re: New XFS git tree on oss.sgi.com
References: <492BA7AD.5080007@sgi.com> <20081125081644.GA20644@infradead.org>
	<492C0B3D.3040002@thebarn.com> <492CA07F.1030803@sgi.com>
	<492CC201.3080304@xfs.org>
	<ncc3ah6lyiw.fsf@itchy.melbourne.sgi.com>
	<20081209091725.GA26180@infradead.org> <493E9AB4.1050505@xfs.org>
	<20081209165728.GA18536@infradead.org>
In-Reply-To: <20081209165728.GA18536@infradead.org>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
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
To: Christoph Hellwig <hch@infradead.org>
Cc: xfs@oss.sgi.com

Christoph Hellwig wrote:
> On Tue, Dec 09, 2008 at 10:20:04AM -0600, Russell Cattelan wrote:
>   
>> The problem is that you have a tracking branch for xfs-dev so git wants 
>> to leave your branch untouched
>> until you actually want to update it from the remote branch origin/xfs-dev
>> What you can do is:
>> % git-fetch
>> % git-pull . xfs-dev
>>
>> That will pull the latest xfs-dev stuff into your current branch.
>>     
>
> It might.  But remember more than a single command to update a
> repository is just a braindead design.  Especially if I have to remember
> a branch name.  Even CVS got this right..
>
>   
Agreed,  I'm not going to defend git cmds, frankly I find most of them 
confusing
and poorly documented. It seems like the only way to figured this stuff 
out is
read as many howto's as possible and then make some swags.

What I did was clone the tree and then have my "master" branch track 
origin/xfs-dev
vs origin/master. That way I can just do git-pulls and have an to date 
xfs-dev tree.

-Russell

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
