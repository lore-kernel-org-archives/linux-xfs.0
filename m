Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 2BC917CA1
	for <xfs@oss.sgi.com>; Tue, 27 Sep 2016 12:04:57 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 9F9DCAC001
	for <xfs@oss.sgi.com>; Tue, 27 Sep 2016 10:04:53 -0700 (PDT)
Received: from userp1040.oracle.com (userp1040.oracle.com [156.151.31.81]) by
	cuda.sgi.com with ESMTP id 7ls8yUuzAU1TAzIz (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Tue, 27 Sep 2016 10:04:48 -0700 (PDT)
Date: Tue, 27 Sep 2016 10:04:43 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: Clarification required about xfs_metadump and xfs_mdrestore
Message-ID: <20160927170443.GR9314@birch.djwong.org>
References: <CAOSFFyjWR4ASud5aSoYTJKweWA244oMwT9_LRSzwnr0Qftg7Eg@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <CAOSFFyjWR4ASud5aSoYTJKweWA244oMwT9_LRSzwnr0Qftg7Eg@mail.gmail.com>
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
To: murali krishna <murali.marimekala@gmail.com>
Cc: xfs@oss.sgi.com

On Tue, Sep 27, 2016 at 09:49:11AM -0400, murali krishna wrote:
> Hi All,
> 
> Got your email id from Nathan Scott.
> 
> Could you please clarify the reasons behind stating below statement in
> xfs_metadump man page.
> 
> 
> 
> *xfs_metadump should not be used for any purposes other than for
>  debugging and reporting filesystem problems*
> Man page: http://man7.org/linux/man-pages/man8/xfs_metadump.8.html
> 
> I am trying to encrypt my existing xfs drive (/dev/sda2) and would like to
> backup metadata using xfs_metadump and restore it back using xfs_mdrestore
> after encrypting my drive. In order to retain entire contents of my
> realtime partition (/dev/sda1), I need to perform this step.
> 
> Can I use xfs_metadump to backup meta-data of xfs  and restore it back
> successfully ?
> Why xfs_metadump should be specifically used as debugging tool ? Please
> clarify ?

Uh.... if your goal is to back up data, reformat the storage with a crypto
layer, and then restore the data, why not just use xfsdump/xfsrestore?
Your data will end up all nicely defragmented, too.

--D

> 
> Thanks in Advance,
> Murali

> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
