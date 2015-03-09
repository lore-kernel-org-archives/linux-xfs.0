Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 039D07F4E
	for <xfs@oss.sgi.com>; Mon,  9 Mar 2015 12:34:23 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 722ADAC005
	for <xfs@oss.sgi.com>; Mon,  9 Mar 2015 10:34:19 -0700 (PDT)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id zBxantbkTguv7ung for <xfs@oss.sgi.com>;
	Mon, 09 Mar 2015 10:34:16 -0700 (PDT)
Message-ID: <54FDD995.5080307@sandeen.net>
Date: Mon, 09 Mar 2015 13:34:13 -0400
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: xfs_repair segfault
References: <1145328183.409860.1425916240318.JavaMail.zimbra@rvx.is>
	<54FDC6FC.1070303@sandeen.net>
	<572429630.410924.1425918276266.JavaMail.zimbra@rvx.is>
In-Reply-To: <572429630.410924.1425918276266.JavaMail.zimbra@rvx.is>
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
To: Rui Gomes <rgomes@rvx.is>
Cc: omar <omar@rvx.is>, xfs <xfs@oss.sgi.com>

On 3/9/15 12:24 PM, Rui Gomes wrote:
> Hello Eric, 
> 
> I would love to send you the xfs metadump but it segfaults as well.

woohoo!  \o/

> This is the output of xfs_repair truncated:
> 
...

> no . entry for directory 260215042
> no .. entry for directory 260215042
> problem with directory contents in inode 260215042
> would have cleared inode 260215042
> bad nblocks 7 for inode 260256256, would reset to 0
> bad nextents 1 for inode 260256256, would reset to 0
> entry "                 kchnfig" in shortform directory 260256256 references invalid inode 28428972647780227
> entry contains illegal character in shortform dir 260256256
> would have junked entry "kchnfig" in directory inode 260256256
> entry "                                                  " in shortform directory 260256256 references invalid inode 0
> size of last entry overflows space left in in shortform dir 260256256, would reset to -1
> *** buffer overflow detected ***: /usr/sbin/xfs_repair terminated

Ok, looking at the sheer number of errors, I really wonder what happened to the fs.

You''d do well to be 100% sure that storage is OK, and that you're not trying to
repair a filesytem on scrambled disks but in any case, xfs should not segfault.

But anyway, this:

> size of last entry overflows space left in in shortform dir 260256256, would reset to -1

is a good clue; it must be in here:

                        if (i == num_entries - 1)  {
                                namelen = ino_dir_size -
                                        ((__psint_t) &sfep->name[0] -
                                         (__psint_t) sfp);
                                do_warn(
_("size of last entry overflows space left in in shortform dir %" PRIu64 ", "),
                                        ino);
                                if (!no_modify)  {
                                        do_warn(_("resetting to %d\n"),
                                                namelen);
                                        sfep->namelen = namelen;
                                        *dino_dirty = 1;

which means the -1 namelen memmove choked on came from:

ino_dir_size - ((__psint_t) &sfep->name[0] - (__psint_t) sfp);

and those come from:

sfp = (struct xfs_dir2_sf_hdr *)XFS_DFORK_DPTR(dip) = ((char *)dip + xfs_dinode_size(dip->di_version))
ino_dir_size = be64_to_cpu(dip->di_size);
sfep = ... xfs_dir2_sf_firstentry(sfp);

We could just be defensive against a negative namelen, but maybe we should
understand a bit more clearly how we got here.

Might start by trying:

# xfs_db -c "inode 260256256" -c "p" /dev/whatever

and show us what you get.

-Eric

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
