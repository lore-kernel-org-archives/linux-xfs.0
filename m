Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id D20917F60
	for <xfs@oss.sgi.com>; Mon, 24 Nov 2014 12:09:55 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id C0888304066
	for <xfs@oss.sgi.com>; Mon, 24 Nov 2014 10:09:52 -0800 (PST)
Received: from mx2.suse.de (cantor2.suse.de [195.135.220.15]) by cuda.sgi.com
	with ESMTP id BIE7ytGivRCsEeJO (version=TLSv1 cipher=AES256-SHA
	bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Mon, 24 Nov 2014 10:09:51 -0800 (PST)
Date: Mon, 24 Nov 2014 19:09:51 +0100
From: David Sterba <dsterba@suse.cz>
Subject: Re: [PATCH 1/4] fs: split update_time() into update_time() and
	write_time()
Message-ID: <20141124180951.GD26471@twin.jikos.cz>
References: <1416599964-21892-1-git-send-email-tytso@mit.edu>
	<1416599964-21892-2-git-send-email-tytso@mit.edu>
	<1416600528.24312.10@mail.thefacebook.com>
	<20141121214245.GG7112@thunk.org>
	<20141124163830.GA26471@twin.jikos.cz>
	<20141124172216.GC31339@thunk.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20141124172216.GC31339@thunk.org>
Reply-To: dsterba@suse.cz
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
Cc: dsterba@suse.cz, xfs@oss.sgi.com, Chris Mason <clm@fb.com>, linux-fsdevel@vger.kernel.org, Ext4 Developers List <linux-ext4@vger.kernel.org>, linux-btrfs@vger.kernel.org

On Mon, Nov 24, 2014 at 12:22:16PM -0500, Theodore Ts'o wrote:
> On Mon, Nov 24, 2014 at 05:38:30PM +0100, David Sterba wrote:
> > 
> > It is necessary and the whole .update_time callback was added
> > intentionally, see commits
> > 
> > c3b2da314834499f34cba94f7053e55f6d6f92d8
> > fs: introduce inode operation ->update_time
> > 
> > e41f941a23115e84a8550b3d901a13a14b2edc2f
> > Btrfs: move over to use ->update_time
> 
> Being able to signal an error if the time update fails is still
> possible even if we drop update_time(), because the new write_time()
> function will return an error.

Fine, means your change does not break the current status. I was
providing the more complete list of related commits.

> > 2bc5565286121d2a77ccd728eb3484dff2035b58
> > Btrfs: don't update atime on RO subvolumes
> 
> Yes, but this doesn't answer my question about other places where the
> VFS is only checking MS_RDONLY and MNT_READONLY besides just
> update_atime().  Maybe we should be exposing an "is_readonly(inode)"
> inode operations function to address this?

Yes, if this is a lightweight check then it'd would allow to remove the
filesystem-specific checks.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
