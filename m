Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:46854 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1032623AbdDTWnh (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 20 Apr 2017 18:43:37 -0400
Subject: Re: [PATCH v2] xfsprogs: ensure growfs rejects non-existent mount
 point
References: <20170407175809.8540-1-billodo@redhat.com>
 <20170411172235.9361-1-billodo@redhat.com>
 <8ffd0451-3455-dbe5-8905-a3c028a6932f@sandeen.net>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <ccbe5b6d-5040-388e-88f1-18ef7bd673d1@sandeen.net>
Date: Thu, 20 Apr 2017 17:43:36 -0500
MIME-Version: 1.0
In-Reply-To: <8ffd0451-3455-dbe5-8905-a3c028a6932f@sandeen.net>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Bill O'Donnell <billodo@redhat.com>, linux-xfs@vger.kernel.org


On 4/20/17 5:22 PM, Eric Sandeen wrote:
> On 4/11/17 12:22 PM, Bill O'Donnell wrote:


>> +/*
>> + * Find the FS table entry for the given path. Compare
>> + * the path to mountpoint entries in the table.
>> + */
>> +struct fs_path *
>> +fs_table_lookup_mount(
>> +	const char *dir)
>> +{
>> +	uint		i;
>> +	dev_t		dev = 0;
>> +
>> +	if (fs_device_number(dir, &dev))
>> +		return NULL;
>> +
>> +	for (i = 0; i < fs_count; i++) {
>> +		if (strcmp(fs_table[i].fs_dir, dir) == 0)
>> +			return &fs_table[i];

Oh, and I think we need to test the flags on the
entry to be sure that it is a FS_MOUNT_POINT as well,
and not a project path.

-Eric

>> +	}
>> +	return NULL;
>> +}
>> +
>>  static int
>>  fs_table_insert(
>>  	char		*dir,
>>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
