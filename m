Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 77B457F3F
	for <xfs@oss.sgi.com>; Tue,  7 Oct 2014 14:46:01 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 62C9F8F8049
	for <xfs@oss.sgi.com>; Tue,  7 Oct 2014 12:45:58 -0700 (PDT)
Received: from mail-pa0-f47.google.com (mail-pa0-f47.google.com
	[209.85.220.47]) by cuda.sgi.com with ESMTP id CWE90yDShMNoRRHj
	(version=TLSv1 cipher=RC4-SHA bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Tue, 07 Oct 2014 12:45:57 -0700 (PDT)
Received: by mail-pa0-f47.google.com with SMTP id rd3so7631903pab.6
	for <xfs@oss.sgi.com>; Tue, 07 Oct 2014 12:45:56 -0700 (PDT)
Mime-Version: 1.0 (Mac OS X Mail 7.3 \(1878.6\))
Subject: Re: [PATCH 03/12] xfs: Set allowed quota types
From: Andreas Dilger <adilger@dilger.ca>
In-Reply-To: <20141007192935.GF30038@quack.suse.cz>
Date: Tue, 7 Oct 2014 13:46:20 -0600
Message-Id: <3391F66C-E2A7-4FC8-8696-3C1600D54DA9@dilger.ca>
References: <1412191894-9113-1-git-send-email-jack@suse.cz>
	<1412191894-9113-4-git-send-email-jack@suse.cz>
	<20141006203028.GB2301@dastard>
	<20141007192935.GF30038@quack.suse.cz>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============7861140210275271326=="
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Jan Kara <jack@suse.cz>
Cc: Dave Kleikamp <shaggy@kernel.org>, jfs-discussion@lists.sourceforge.net, tytso@mit.edu, Jeff Mahoney <jeffm@suse.de>, Mark Fasheh <mfasheh@suse.com>, reiserfs-devel@vger.kernel.org, xfs@oss.sgi.com, cluster-devel <cluster-devel@redhat.com>, Joel Becker <jlbec@evilplan.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Ext4 Developers List <linux-ext4@vger.kernel.org>, Steven Whitehouse <swhiteho@redhat.com>, ocfs2-devel@oss.oracle.com


--===============7861140210275271326==
Content-Type: multipart/signed; boundary="Apple-Mail=_25A6EF2A-EBB8-4C4D-A067-5217C5746133"; protocol="application/pgp-signature"; micalg=pgp-sha1


--Apple-Mail=_25A6EF2A-EBB8-4C4D-A067-5217C5746133
Content-Transfer-Encoding: 7bit
Content-Type: text/plain;
	charset=us-ascii

On Oct 7, 2014, at 1:29 PM, Jan Kara <jack@suse.cz> wrote:
> On Tue 07-10-14 07:30:28, Dave Chinner wrote:
>> On Wed, Oct 01, 2014 at 09:31:25PM +0200, Jan Kara wrote:
>>> We support user, group, and project quotas. Tell VFS about it.
>>> 
>>> CC: xfs@oss.sgi.com
>>> CC: Dave Chinner <david@fromorbit.com>
>>> Signed-off-by: Jan Kara <jack@suse.cz>
>>> ---
>>> fs/xfs/xfs_super.c | 2 ++
>>> 1 file changed, 2 insertions(+)
>>> 
>>> diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
>>> index b194652033cd..b32e998e8cbc 100644
>>> --- a/fs/xfs/xfs_super.c
>>> +++ b/fs/xfs/xfs_super.c
>>> @@ -1419,6 +1419,8 @@ xfs_fs_fill_super(
>>> 	sb->s_export_op = &xfs_export_operations;
>>> #ifdef CONFIG_XFS_QUOTA
>>> 	sb->s_qcop = &xfs_quotactl_operations;
>>> +	sb->s_dquot.allowed_types = (1 << USRQUOTA) | (1 << GRPQUOTA) |
>>> +				    (1 << PRJQUOTA);
>> 
>> Would it be better to define masks for these rather than open
>> coding these shifts everywhere?
>  I can do that. Any suggestion for a name? I was thinking about it for a
> while and couldn't come up with anything satisfactory...

Better to have QUOTA at the start, and TYPE in the name, so maybe:

enum quota_types {
	QUOTA_TYPE_USR = 1 << USRQUOTA,
	QUOTA_TYPE_GRP = 1 << GRPQUOTA,
	QUOTA_TYPE_PRJ = 1 << PRJQUOTA,
};

or maybe "enum quota_type_mask" or similar.

I prefer named enums over #defines since this makes it more clear
when declaring variables like "allowed_types" what valid values are
instead of just "int" that someone might mistakenly set to USRQUOTA
directly or something.

Cheers, Andreas






--Apple-Mail=_25A6EF2A-EBB8-4C4D-A067-5217C5746133
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename=signature.asc
Content-Type: application/pgp-signature;
	name=signature.asc
Content-Description: Message signed with OpenPGP using GPGMail

-----BEGIN PGP SIGNATURE-----
Comment: GPGTools - http://gpgtools.org

iQIVAwUBVDRDDHKl2rkXzB/gAQKQ1hAAlea+fNuBUbta4vk/YkFa/+05+8K9ppKo
17TxlDnme+uXuvcUBsj8FgS94++A3/oEZusByqm1kznm/ID4fGlEYwOkwnOT6RlG
ARWksyI/dbrC5WEEw4mWILQJLLxC+nPCj03qM8/oP9jRUNdwvFLPpLVx8nBHHwas
FCs9Oic2EvDqSV61iqat6k7MHsUuY5yrbHyrqqUtDLHUv82YDCXYAeEvtqKluzC8
jvyRTvy3PcKyOM3TnaGClrQOE5ncHcrBz99YSK3fcvKCEuII2BNXCRVmfN48T8qm
X4K7vgoMIF2HDxwnohUJh6FAzERMHbIm1muEN0JChplVi4m5Z63qKvflgqagaKAL
i4qcFRcH5C4l8OUrJdYdNt23Ka9B2KKW7HLy0b/v6MdbiwjVaC3rRh/h5ZpX2seg
BLxQtqBkdMf7o1NDpUbWJZuiWNt6tEfUFykGG8wK4toFc/xgQ7kvIWERELUCDOug
J6kYlxqGZUn208ZJmZg516J38z1VVQr7Xy+bhF9zifZgOqOWuOmRkFtAWnmK7/W8
3/LYNHpmTJqeQMMz26KWjYr7RqpvLGwsSOa4V8jQC3oBllKJKdm2CUc4G2t/wP38
MC800equzdJKvF8zoOy1+R8877zLXnrR/UkYrnHxRgEn9sY5Y19bnIH/7PYBpEVj
k7SxUkGyBdQ=
=1Ues
-----END PGP SIGNATURE-----

--Apple-Mail=_25A6EF2A-EBB8-4C4D-A067-5217C5746133--


--===============7861140210275271326==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============7861140210275271326==--
