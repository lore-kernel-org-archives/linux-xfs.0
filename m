Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o5TND2Ix097068 for <xfs@oss.sgi.com>; Tue, 29 Jun 2010 18:13:02 -0500
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 25FCB4193F4
	for <xfs@oss.sgi.com>; Tue, 29 Jun 2010 16:15:46 -0700 (PDT)
Received: from mail.internode.on.net (bld-mail14.adl6.internode.on.net
	[150.101.137.99]) by cuda.sgi.com with ESMTP id
	UOvi5wBs2CbrCOHN for <xfs@oss.sgi.com>;
	Tue, 29 Jun 2010 16:15:46 -0700 (PDT)
Date: Wed, 30 Jun 2010 09:15:43 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: XFS and Extended ACLs
Message-ID: <20100629231543.GC6590@dastard>
References: <001636458d40cae4e1048a2bf4e9@google.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <001636458d40cae4e1048a2bf4e9@google.com>
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
To: nailman23@gmail.com
Cc: xfs@oss.sgi.com

On Tue, Jun 29, 2010 at 02:21:42PM +0000, nailman23@gmail.com wrote:
> Hi All,
> 
> I have an issue with extended ACLs. The situation is as follows:
> 1) There are two users (UserA and UserB)
> 2) They belong to the same group (users)
> 3) The SAMBA share called "test" has user access enabled for UserA and UserB
> 4) The UserA creates test.docx file on the "test" share and he
> becomes the owner of the file.
> 5) Then UserB edits the test.docx file and save changes. After that
> UserB becomes the owner. It is not an issue because when editing the
> file Word creates new temporary file and then, during saving,
> overwrites the original file. The issue is when you check ACLs entry
> you will see that UserA has his own ACLs entries, although he
> already belongs to the "users" groups.
> 
> This occurs when the share has XFS file system in the bottom.
> 
> Then I have created an ext3 file system on the logical volume and
> after performing all steps, the UserB was owner of the file, but the
> UserA was no longer listed in ACLs entries.

Can you provide a script that demonstrates the problem?

> It seems the issue comes from XFS and the way as the XFS handles the
> ACLs permissions.

XFS uses the most of the generic code for getting and setting ACLs,
so there shouldn't be any difference unless there is a bug or you
are using an old kernel. What kernel are you running?

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
