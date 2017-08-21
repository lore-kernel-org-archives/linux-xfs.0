Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:33342 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753739AbdHUULn (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 21 Aug 2017 16:11:43 -0400
Subject: Re: xfs_metadump as a backup tool
References: <c8f366449091c278310acb5fbb13a11f@assyoma.it>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <be09cfb0-39ab-9645-468b-79d6a81aaec8@sandeen.net>
Date: Mon, 21 Aug 2017 15:11:42 -0500
MIME-Version: 1.0
In-Reply-To: <c8f366449091c278310acb5fbb13a11f@assyoma.it>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Gionatan Danti <g.danti@assyoma.it>, linux-xfs@vger.kernel.org

On 8/21/17 2:59 PM, Gionatan Danti wrote:
> Hi all,
> I wish to ask if someone is using xfs_metadump as a "real" backup tool - ie: in production.

Short answer is "No," because:
xfs_metadump is only a diagnostic tool.  It is not tested or supported for any other use.

If nothing else, on a normal live filesystem your metadata and data is constantly changing; if you replay old metadata over a filesystem, you'll end up pointing to file data blocks that are incorrect.

If you really truly have only statically-allocated files from start to finish, then maybe... 

But more than anything else, the tool was not designed or tested for anything other than developer diagnostics.

For disaster recovery, having periodic metadata snapshots might come in handy from a forensic POV, but I would not rely on this as a primary part of your normal backup/recovery scheme.

> I was wondering how to lower recovery time in case of filesystem corruption, and the idea of using xfs_metadump + xfs_mdrestore struck me.
> 
> I plan to have a single, relatively big XFS volume with an handfull of fully preallocated large files (VM disk images). Basically, I was thinking about:
> - take a LVM snapshot;
> - mount the snap volume as read-only;
> - copy the user data (via tar/rsync/whatever);
> - additionally, xfs_metadump its metadata content.

If you've already done a proper backup wit tar/rsync/(xfsdump?) then you have everything you need to restore the filesystem without resorting to xfs_metadump cleverness, right?

> If a major filesystem corruption occour, as a first step I should be able to simply restore its metadata with xfs_mdrestore and re-gain access to files/data blocks. A potential pitfall would be related to extents that at the time of xfs_metadump where marked as "unwritten" but later were written - restoring the old metadata will immediately turn user data into zeroes. It is possible to fully allocate a file *without* marking the allocated extents as "unwritten"? Yes, I know this has security implications...

No, it's not possible to preallocate space on xfs without marking it as unwritten.

-Eric

> Is this a good idea? I am missing something?
> Thanks.
> 
