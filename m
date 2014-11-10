Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 539287F72
	for <xfs@oss.sgi.com>; Mon, 10 Nov 2014 12:56:57 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 001C7AC1EA
	for <xfs@oss.sgi.com>; Mon, 10 Nov 2014 10:56:53 -0800 (PST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id wSrhSJbfKNweigzl (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Mon, 10 Nov 2014 10:56:53 -0800 (PST)
Received: from int-mx09.intmail.prod.int.phx2.redhat.com
	(int-mx09.intmail.prod.int.phx2.redhat.com [10.5.11.22])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id sAAIuqpK010824
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256
	verify=FAIL) for <xfs@oss.sgi.com>; Mon, 10 Nov 2014 13:56:52 -0500
Received: from hades.localdomain (ovpn-113-69.phx2.redhat.com [10.3.113.69])
	by int-mx09.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP
	id sAAIumxP001316
	(version=TLSv1/SSLv3 cipher=AES128-SHA bits=128 verify=NO)
	for <xfs@oss.sgi.com>; Mon, 10 Nov 2014 13:56:51 -0500
Date: Mon, 10 Nov 2014 16:56:47 -0200
From: Carlos Maiolino <cmaiolino@redhat.com>
Subject: Re: [PATCH 2/2] Add support to RENAME_EXCHANGE flag
Message-ID: <20141110185644.GA692@hades.localdomain>
References: <1415641272-29383-1-git-send-email-cmaiolino@redhat.com>
	<1415641272-29383-3-git-send-email-cmaiolino@redhat.com>
	<5461002E.8090506@sandeen.net>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <5461002E.8090506@sandeen.net>
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

On Mon, Nov 10, 2014 at 12:13:02PM -0600, Eric Sandeen wrote:
> On 11/10/14 11:41 AM, Carlos Maiolino wrote:
> > Adds a new function named xfs_cross_rename(), responsible to handle requests
> > from sys_renameat2() using RENAME_EXCHANGE flag.
> > 
> > Changelog:
> > 
> > 	V2: refactor xfs_cross_rename() to not duplicate code from xfs_rename()
> 
> Which tree is this against?
> 


It's based on an 'old' version of linux.git, which I was using when I started to
work on this patch, I'll rebase it on top of the current tree.

> Ok, just some style drive-by comments, first -
> 
> EEK ;)  13 args and ~100 chars wide ;)
> 
> You could at least move some of those back to local vars in the
> cross_rename function so you don't have to pass them on the stack.
> It's also customary to pass the transaction pointer as the first arg,
> i.e.:
> 
> 
> There are a few other places where you go well beyond 80 chars, would rather
> not do that if at all possible.
> 
Yes, after reading it on the list, although it works, it looks a mess :( sorry
about it.

I'll wait for some other comments and re-work on it, so, tomorrow I can send a
new version of it.

Thanks for the comments Eric

-- 
Carlos

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
