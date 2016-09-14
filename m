Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 228DD7CA1
	for <xfs@oss.sgi.com>; Wed, 14 Sep 2016 14:54:34 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 8AFADAC003
	for <xfs@oss.sgi.com>; Wed, 14 Sep 2016 12:54:29 -0700 (PDT)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id DTPE2dlFmmclzytB for <xfs@oss.sgi.com>;
	Wed, 14 Sep 2016 12:54:27 -0700 (PDT)
Subject: Re: [PATCH 1/3] xfsprogs: populate fs table with xfs entries first,
	foreign entries last
References: <1473866381-28975-1-git-send-email-billodo@redhat.com>
	<1473866381-28975-2-git-send-email-billodo@redhat.com>
	<b49366ac-d277-a26f-1936-8e736d1c913c@sandeen.net>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <53e9e6c0-c83e-d681-f021-83c97cccbfb6@sandeen.net>
Date: Wed, 14 Sep 2016 14:54:27 -0500
MIME-Version: 1.0
In-Reply-To: <b49366ac-d277-a26f-1936-8e736d1c913c@sandeen.net>
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
To: Bill O'Donnell <billodo@redhat.com>, linux-xfs@vger.kernel.org
Cc: xfs@oss.sgi.com

On 9/14/16 12:50 PM, Eric Sandeen wrote:
>> @@ -113,8 +119,13 @@ path_f(
> Oops, I mentioned this to you as needed, but it's wrong, sorry.
> 
> Just drop this hunk, this is supposed to select path i, not iterate
> over anything.  Sorry for mentioning it.
> 
>> >  		printf(_("value %d is out of range (0-%d)\n"),
>> >  			i, fs_count-1);
>> >  	} else {
>> > -		fs_path = &fs_table[i];
>> > -		pathlist_f();
>> > +		for (i = 0; i < fs_count; i++) {
>> > +			fs_path = &fs_table[i];
>> > +			/* Table is ordered xfs first, then foreign */
>> > +			if (fs_path->fs_flags & FS_FOREIGN && !foreign_allowed)
>> > +				break;
>> > +			pathlist_f();
>> > +		}
>> >  	}
>> >  	return 0;
>> >  }

Oh, right.  You need the test & break in print_f not path_f, otherwise:

# quota/xfs_quota -x
xfs_quota> print
Filesystem          Pathname
    /home               /dev/mapper/vg_bp05-lv_home
    /mnt/test2          /dev/sdc1
(F) /                   /dev/mapper/vg_bp05-lv_root
(F) /boot               /dev/sda1
(F) /mnt/test           /dev/sdb1
xfs_quota> 

"print" gives you foreign filesystems when you didn't ask for them.

-Eric

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
