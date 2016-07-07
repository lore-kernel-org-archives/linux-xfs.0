Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 0FD1D7CFD
	for <xfs@oss.sgi.com>; Thu,  7 Jul 2016 04:27:55 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 6E62BAC02E
	for <xfs@oss.sgi.com>; Thu,  7 Jul 2016 02:27:53 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id Iz7RSm0B6s2CCn6L (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Thu, 07 Jul 2016 02:27:52 -0700 (PDT)
From: "Benjamin Coddington" <bcodding@redhat.com>
Subject: Re: [PATCH] nfsd: allow SCSI layout support without Block layout
Date: Thu, 07 Jul 2016 05:29:03 -0400
Message-ID: <6326BEEA-5EC8-4CA2-B532-CEACB6819D13@redhat.com>
In-Reply-To: <20160706221648.GE12670@dastard>
References: <74871b1ce0d09b21fb67c1b2176695cc1c19169e.1467624319.git.bcodding@redhat.com>
	<20160706091953.GD12670@dastard>
	<73B22D64-6A0B-4B8B-8A4D-6AA7AC26F30D@redhat.com>
	<20160706124326.GA18856@fieldses.org> <20160706221648.GE12670@dastard>
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
To: Dave Chinner <david@fromorbit.com>
Cc: "J. Bruce Fields" <bfields@fieldses.org>, Christoph Hellwig <hch@lst.de>, xfs@oss.sgi.com

On 6 Jul 2016, at 18:16, Dave Chinner wrote:

> On Wed, Jul 06, 2016 at 08:43:26AM -0400, J. Bruce Fields wrote:
>> On Wed, Jul 06, 2016 at 05:58:09AM -0400, Benjamin Coddington wrote:
>>> On 6 Jul 2016, at 5:19, Dave Chinner wrote:
>>>
>>>> On Tue, Jul 05, 2016 at 09:48:47PM -0400, Benjamin Coddington wrote:
>>>>> We shouldn't have to configure both NFSD_BLOCKLAYOUT and
>>>>> NFSD_SCSILAYOUT if
>>>>> all we want are SCSI layouts on the server, so define the xfs export
>>>>> operations for either configuration.
>>>>>
>>>>> Signed-off-by: Benjamin Coddington <bcodding@redhat.com>
>>>>
>>>> I don't really like exploding config option dependencies into
>>>> subsystems that aren't actually related to the config options.
>>>> It's confusing enough laready that we've got XFS code dependent on
>>>> PNFSD config options without adding more to it. Instead, I'd
>>>> suggest this should be resolved in the kconfig files. i.e. make
>>>> CONFIG_NFSD_SCSILAYOUT=y select CONFIG_NFSD_BLOCKLAYOUT to resolve
>>>> the config dependency at config time.
>>>
>>> But the point is to leave CONFIG_NFSD_BLOCKLAYOUT undefined
>>> otherwise knfsd
>>> will advertise block layouts to clients -- which we don't want.
>
> Pnfsd layout is determined at compile time?  That's seems less than
> useful to me for distros wanting to support for multiple layout
> types in the one kernel. i.e. Shouldn't the layout to be advertised
> be something like a per-export configuration option rather than
> determined at compile time define?
>
>>> Would a third define specific for xfs_export_operations that gets
>>> set in kconfig files work for you?  Something like XFS_PNFS_EXPORT_OPS.
>>
>> That makes sense to me....
>
> Sounds good, but I'd drop the "XFS_" prefix because when multiple
> filesytems end up supporting it, we don't want to have to select
> every single one of them from the PNFSD config options...

I now think using PNFS_EXPORT_OPS is too general for all layouts, since nfsd
might support additional layout types that require other export_operations
that have nothing to do with out-of-filesystem access to the storage media.
Also, I believe there's been some interest in using the map_blocks and
commit_blocks interface elsewhere.  So, perhaps something like
CONFIG_BLOCK_EXPORT_OPS would be more appropriate. I'm going to run with
that unless someone disagrees.

I'll also send this as a follow-up to this patch instead of a v2, since
combining both changes into one patch would hide this fix to include these
operations for both SCSI and BLOCK layout types.

Ben

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
