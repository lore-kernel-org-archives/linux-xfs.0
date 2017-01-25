Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:59618 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751017AbdAYAzE (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 24 Jan 2017 19:55:04 -0500
Subject: Re: [PATCH v7 1/5] xfs_db: sanitize agcount on load
References: <148494391629.5256.3328772079712970611.stgit@birch.djwong.org>
 <148494392247.5256.10692618169002348643.stgit@birch.djwong.org>
 <20170123213108.GD31202@birch.djwong.org>
 <6ad3798a-c3f5-fd8f-ab05-62c0f878290c@sandeen.net>
 <20170125002157.GH9134@birch.djwong.org>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <98b461d0-74f8-865f-94aa-1bc2b9fa9a1a@sandeen.net>
Date: Tue, 24 Jan 2017 18:55:02 -0600
MIME-Version: 1.0
In-Reply-To: <20170125002157.GH9134@birch.djwong.org>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: sandeen@redhat.com, linux-xfs@vger.kernel.org

On 1/24/17 6:21 PM, Darrick J. Wong wrote:
> On Tue, Jan 24, 2017 at 04:52:59PM -0600, Eric Sandeen wrote:
>> Before we get into libxfs_initialize_perag and try to blindly
>> allocate a perag struct for every (possibly corrupted number of)
>> AGs, see if we can read the last one.  If not, assume it's corrupt,
>> and load only the first AG.
>>
>> Do this only for an arbitrarily high-ish agcount, so that normal-ish
>> geometry on a possibly truncated file or device will still do
>> its best to make all readable AGs available.
>>
>> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
>> ---
>>
>> diff --git a/libxfs/init.c b/libxfs/init.c
>> index a08575a..ca5101e 100644
>> --- a/libxfs/init.c
>> +++ b/libxfs/init.c
>> @@ -817,6 +817,28 @@ libxfs_mount(
>>  			return NULL;
>>  	}
>>  
>> +	/*
>> +	 * libxfs_initialize_perag will allocate a perag structure for each AG.
>> +	 * If agcount is corrupted and insanely high, this will OOM the box.
>> +	 * If the agount seems (arbitrarily) high, try to read what would be
>> +	 * the last AG, and if that fails, just read the first one and let
>> +	 * the user know what happened.
>> +	 */
>> +	if (sbp->sb_agcount > 10000) {
> 
> 10,000 isn't all that high -- that's only 960K worth of perag structs.
> Also,

It's not a lot of memory but it's a lot of AGs.  *shrug* doesn't really
matter what the number is, I just wanted most common-case xfs_db
invocations to work even if for some reason we can't read the last AG,
due to a truncated image or whatever.  10,000 would be unusual.
If you want a million, fine by me.

> <create 200gb /dev/mapper/moo>
> 
> # mkfs.xfs -f -b size=4096 -d agsize=4096b /dev/mapper/moo
> meta-data=/dev/mapper/moo        isize=512    agcount=12800, agsize=4096 blks
> 
> Ok, admittedly I'm trolling here.  Maybe a better limit would be
> 1,000,000 AGs?  That's at least 2TB with the minimum AG size, and 100MB
> of RAM.
> 
> (Really I'd say 10 million but I've been brainwashed by the people
> fscking 16TB filesystems on embedded arm boxen with 256M of RAM...)

ok, one million it is.

>> +		error = xfs_read_agf(mp, NULL, sbp->sb_agcount - 1, 0, &bp);
>> +		if (error) {
> 
> __read_buf sends back -EIO for any zero-byte pread, including reads past
> the end of the device, which makes a media error looks the same as a
> too-small device.  Also, if the AGF is present but garbage then we'll
> get -EFSCORRUPTED here, right?

Oh, I guess so.  Could compare to -EIO?  This was the reason for only
taking this "media error" risk for a crazily large number of AGs, which
is /probably/ wrong in the first place.  Chances of /really/ having a
million AGs and then happening upon a media error on the millionth AG
seems pretty small.

> I think I like the idea of computing the AGF location and comparing to
> the device size to guess that our geometry is crazy.

Meh, ok, but maybe with some slop.  If agcount >= 1 million, /and/ last
AG > 2x device size, bail.  Howzat?

-Eric

> --D
> 
>> +			fprintf(stderr, _("%s: read of AG %d failed\n"),
>> +						progname, sbp->sb_agcount);
>> +			if (!(flags & LIBXFS_MOUNT_DEBUGGER))
>> +				return NULL;
>> +			fprintf(stderr, _("%s: limiting reads to AG 0\n"),
>> +								progname);
>> +			sbp->sb_agcount = 1;
>> +		}
>> +		if (bp)
>> +			libxfs_putbuf(bp);
>> +	}
>> +
>>  	error = libxfs_initialize_perag(mp, sbp->sb_agcount, &mp->m_maxagi);
>>  	if (error) {
>>  		fprintf(stderr, _("%s: perag init failed\n"),
>>
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
