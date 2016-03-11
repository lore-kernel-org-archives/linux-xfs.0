Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 7FCAB7CAE
	for <xfs@oss.sgi.com>; Fri, 11 Mar 2016 14:05:46 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 4E413304039
	for <xfs@oss.sgi.com>; Fri, 11 Mar 2016 12:05:37 -0800 (PST)
Received: from mail-ig0-f171.google.com (mail-ig0-f171.google.com
	[209.85.213.171]) by cuda.sgi.com with ESMTP id
	TywfdpwyveDSfd1q (version=TLSv1.2
	cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Fri, 11 Mar 2016 12:05:36 -0800 (PST)
Received: by mail-ig0-f171.google.com with SMTP id vf5so18900093igb.0
	for <xfs@oss.sgi.com>; Fri, 11 Mar 2016 12:05:36 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CAHc6FU4t3yisCM=MXrHRmCja_A8eZOpVa1smJ0gUhv+vuUAuXA@mail.gmail.com>
References: <1456733847-17982-1-git-send-email-agruenba@redhat.com>
	<20160311140134.GA14808@infradead.org>
	<CAHc6FU4t3yisCM=MXrHRmCja_A8eZOpVa1smJ0gUhv+vuUAuXA@mail.gmail.com>
From: Steve French <smfrench@gmail.com>
Date: Fri, 11 Mar 2016 14:05:16 -0600
Message-ID: <CAH2r5mv3OTmPOQBV7xc-uZmB0gWxykXOCEVOcybx3tbHiViTZg@mail.gmail.com>
Subject: Re: [PATCH v18 00/22] Richacls (Core and Ext4)
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
To: Andreas Gruenbacher <agruenba@redhat.com>
Cc: "J. Bruce Fields" <bfields@fieldses.org>, Linux NFS Mailing List <linux-nfs@vger.kernel.org>, Theodore Ts'o <tytso@mit.edu>, "linux-cifs@vger.kernel.org" <linux-cifs@vger.kernel.org>, Linux API <linux-api@vger.kernel.org>, Trond Myklebust <trond.myklebust@primarydata.com>, LKML <linux-kernel@vger.kernel.org>, XFS Developers <xfs@oss.sgi.com>, Christoph Hellwig <hch@infradead.org>, Andreas Dilger <adilger.kernel@dilger.ca>, Alexander Viro <viro@zeniv.linux.org.uk>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Jeff Layton <jlayton@poochiereds.net>, linux-ext4 <linux-ext4@vger.kernel.org>, Anna Schumaker <anna.schumaker@netapp.com>

On Fri, Mar 11, 2016 at 10:11 AM, Andreas Gruenbacher
<agruenba@redhat.com> wrote:
> On Fri, Mar 11, 2016 at 3:01 PM, Christoph Hellwig <hch@infradead.org> w
> The model is designed specifically to be compliant with the POSIX
> permission model. What assumptions are you talking about?
>
>> especially by adding allow and deny ACE at the same time.
>
> I remember from past discussions that a permission model like the
> POSIX ACL model that doesn't have DENY ACEs would be more to your
> liking. This argument is dead from the start though: NFSv4 ACLs
> without DENY ACEs cannot represent basic file permissions like 0604
> where the owning group has fewer permissions than others, for example
> (see the richaclex(7) man page). We would end up with a permission
> model that isn't even compatible with the traditional POSIX file
> permission model, one which nobody else implements or cares about.

NFSv4.1 (and later) and Samba's (and cifs.ko and NTFS-3g) ACL model are close
enough that doing a common approach that helps all three seems
very reasonable.

A loosely related question is what can be done for tools around existing
interfaces for ACLs.  I recently found out NTFS-3g has this xattr:

    static const char nf_ns_xattr_ntfs_acl[] = "system.ntfs_acl";

which allows you to query system.ntfs_acl xattr to get their full ACL
(I hope) from NTFS but it hard to read without tools to parse
the blobs better.  I was prototyping adding this to cifs.ko for
the most current (SMB3 and later) protocol dialects at least
to allow backup and debug tools to use this to get the actual
ACL.   cifs.ko ACL should match almost exactly to NTFS-3g's but
I wish I could find some tools that use this xattr so I could try
comparing this with cacls.exe output and smbcacls (samba tool)
for display detailed ACL information.  Any idea of disk management tools
for dumping/viewing/editing ntfs ACLs on Linux for comparison?

>> It also doesn't help with the issue that the main thing it's trying
>> to be compatible with (Windows) actually uses a fundamentally different
>> identifier to apply the ACLs to - as long as you're still limited
>> to users and groups and not guids we'll still have that mapping problem
>> anyway.
>
> Samba has been dealing with mapping between SIDs and UIDs/GIDs for a
> long time, and it's working acceptably well.
>
> We could store SIDs in ACEs, but that wouldn't make the actual
> problems go away: Files on Linux have an owner and an owning group
> which are identitifed by UID/GID, whereas a file is owned by a SID
> which can be either a user or a group in a SID world. Also, processes
> on Linux have an owner and a list of groups which are identified by
> UID/GID, so any SIDs stored in filesystems would never match a
> process, anyway.

Samba's SID<->Username and SID<->UID mapping does work
acceptably well, if a bit "over-configurable" ie with
many choices for how it is done.

 (the related RFC2307 mapping needed for mapping usernames
to uids across an enterprise, which Samba's winbind can
also do is helpful much more broadly - since, unlike a uid
which is too small, the username in an NFS ACLs
are basically a one to one mapping for Samba to SIDs (there
are may samba vfs modules for different OS that already
do this, including a one for an earlier version of Linux RichACLs)

Sounds like I need to quickly rework the SMB3 ACL helper functions
for cifs.ko

Also do you know where is the current version of the corresponding
vfs_richacl for
Samba which works with the current RichACL format?


-- 
Thanks,

Steve

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
