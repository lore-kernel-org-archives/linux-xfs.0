Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 05ED87F82
	for <xfs@oss.sgi.com>; Fri,  3 May 2013 14:05:22 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id CAE248F8065
	for <xfs@oss.sgi.com>; Fri,  3 May 2013 12:05:18 -0700 (PDT)
Received: from dkim2.fusionio.com (dkim2.fusionio.com [66.114.96.54]) by
	cuda.sgi.com with ESMTP id kxEHSOlsovRyH1vB (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Fri, 03 May 2013 12:05:17 -0700 (PDT)
Received: from mx1.fusionio.com (unknown [10.101.1.160])
	by dkim2.fusionio.com (Postfix) with ESMTP id 51C409A0420
	for <xfs@oss.sgi.com>; Fri,  3 May 2013 13:05:17 -0600 (MDT)
Date: Fri, 3 May 2013 15:05:14 -0400
From: Josef Bacik <jbacik@fusionio.com>
Subject: Re: [PATCH] xfstests 311: test fsync with dm flakey V3
Message-ID: <20130503190514.GD12414@localhost.localdomain>
References: <1367003639-17621-1-git-send-email-jbacik@fusionio.com>
	<51840047.4020908@sgi.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <51840047.4020908@sgi.com>
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
To: Rich Johnston <rjohnston@sgi.com>
Cc: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>, Josef Bacik <JBacik@fusionio.com>, "xfs@oss.sgi.com" <xfs@oss.sgi.com>

On Fri, May 03, 2013 at 12:21:59PM -0600, Rich Johnston wrote:
> Thanks for another patch Josef, it has been committed with the change 
> discussed.
> 

Err I forgot to point out I already have a "sync" variable in there so it fails
to compile, we'll need to change the var to do_sync or something.  Want me to
send a patch along?  Thanks,

Josef

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
