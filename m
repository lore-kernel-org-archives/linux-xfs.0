Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 705D27FBB
	for <xfs@oss.sgi.com>; Tue, 18 Feb 2014 02:13:27 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 57ECB304043
	for <xfs@oss.sgi.com>; Tue, 18 Feb 2014 00:13:24 -0800 (PST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id fsEvZKapEthtDQqx for
	<xfs@oss.sgi.com>; Tue, 18 Feb 2014 00:13:23 -0800 (PST)
Date: Tue, 18 Feb 2014 09:13:17 +0100 (CET)
From: =?ISO-8859-15?Q?Luk=E1=A8_Czerner?= <lczerner@redhat.com>
Subject: Re: [PATCH 1/6] ext4: Update inode i_size after the preallocation
In-Reply-To: <20140217232100.GA26580@thunk.org>
Message-ID: <alpine.LFD.2.00.1402180911110.2216@localhost.localdomain>
References: <1392649703-10772-1-git-send-email-lczerner@redhat.com>
	<1392649703-10772-2-git-send-email-lczerner@redhat.com>
	<9288BED9-A44E-4ACC-9A3D-BC086AB4E121@dilger.ca>
	<20140217232100.GA26580@thunk.org>
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
To: Theodore Ts'o <tytso@mit.edu>
Cc: Andreas Dilger <adilger@dilger.ca>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Ext4 Developers List <linux-ext4@vger.kernel.org>, xfs@oss.sgi.com

On Mon, 17 Feb 2014, Theodore Ts'o wrote:

> Date: Mon, 17 Feb 2014 18:21:00 -0500
> From: Theodore Ts'o <tytso@mit.edu>
> To: Andreas Dilger <adilger@dilger.ca>
> Cc: Lukas Czerner <lczerner@redhat.com>,
>     Ext4 Developers List <linux-ext4@vger.kernel.org>,
>     linux-fsdevel <linux-fsdevel@vger.kernel.org>, xfs@oss.sgi.com
> Subject: Re: [PATCH 1/6] ext4: Update inode i_size after the preallocation
> 
> On Mon, Feb 17, 2014 at 04:12:14PM -0700, Andreas Dilger wrote:
> > 
> > I don't necessarily agree about this.  Calling fallocate() will not
> > change the user-visible data at all, so there is no reason to e.g.
> > do a new backup of the file or reprocess the contents, or any other
> > reason that an application cares about a changed mtime.
> 
> Well, if i_size has changed, then the visible results of reading from
> the file will change, so in that case I'd argue m_time should change.
> If the results of reading file doesn't change then we can keep m_time
> unchanged --- but since the inode is changing, c_time *should* always
> change any time we've made any changes to the extent tree.
> 
> 	      	  	    	     - Ted

So I guess the consensus is to update m_time only when the inode size
changes in fallocate case. I'll change that in the code.

Thanks!
-Lukas

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
