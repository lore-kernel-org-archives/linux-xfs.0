Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 5C74E7F89
	for <xfs@oss.sgi.com>; Fri,  9 Aug 2013 12:17:54 -0500 (CDT)
Date: Fri, 9 Aug 2013 12:17:50 -0500
From: Ben Myers <bpm@sgi.com>
Subject: Re: prjquota not updating used blocks
Message-ID: <20130809171750.GV1681@sgi.com>
References: <6D3CECD5-FBBF-4946-A0D0-5B0C71E772DD@grc.nia.nih.gov>
	<20130809151957.GZ3111@sgi.com>
	<C33DFB5C-9524-4D7D-8F9A-8E17088CA20E@grc.nia.nih.gov>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <C33DFB5C-9524-4D7D-8F9A-8E17088CA20E@grc.nia.nih.gov>
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
To: "Weber, Charles (NIH/NIA/IRP) [C]" <WeberC@grc.nia.nih.gov>
Cc: xfs@oss.sgi.com

Hey Charles,

On Fri, Aug 09, 2013 at 12:29:20PM -0400, Weber, Charles (NIH/NIA/IRP) [C] wrote:
> When I referred to initialize I meant  running xfs_quota -x project -s name

Hmm.  What if you used 'xfs_quota -x project -s -p /path/to/new/dirs name'?

> When I run xfs_quota -x 'project -c lg'
>
> I do get warnings about project identifier and inheritance but only for the
> new directories that I created and copied the large data sets into. I don't
> get those warning about the earlier files and folders for a given project.

Those warnings refer to not having a project id set in the inode core, and
whether a directory will set it's project id into the inode cores of whatever
you create inside.  Without that project id set in the new files you create,
the quota subsystem won't know which project quota to reserve blocks
against.  That's why your block usage wasn't changing.

> When I run the project -s again it does update the block usage.

Maybe the first try failed to find the new directory?  I'm not sure.

> But I would think the block usage should update automatically.

Could you cut an paste the procedure to you used to create the new directories?

Thanks,
	Ben

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
