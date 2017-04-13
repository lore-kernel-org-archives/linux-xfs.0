Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:55424 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751544AbdDMRBe (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 13 Apr 2017 13:01:34 -0400
Subject: Re: [PATCH 2/2] xfsprogs: update man for metadump about dirty
 log/obfuscation issue
References: <20170413081354.22170-1-jtulak@redhat.com>
 <20170413081354.22170-3-jtulak@redhat.com>
 <20170413120152.GB24893@bfoster.bfoster>
 <CACj3i70UdyecqPjxNG9c=7gWdi1sjigFAPQX+TWYP0omj_2WvQ@mail.gmail.com>
 <324004e7-6809-bca0-8c39-ac7d846d7238@sandeen.net>
 <20170413155003.GV8502@birch.djwong.org>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <b0980f59-2c09-bd15-1d6d-ee40ddd089e4@sandeen.net>
Date: Thu, 13 Apr 2017 12:01:32 -0500
MIME-Version: 1.0
In-Reply-To: <20170413155003.GV8502@birch.djwong.org>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: Jan Tulak <jtulak@redhat.com>, Brian Foster <bfoster@redhat.com>, linux-xfs@vger.kernel.org

On 4/13/17 10:50 AM, Darrick J. Wong wrote:
> On Thu, Apr 13, 2017 at 08:49:52AM -0500, Eric Sandeen wrote:

>> ---
>>
>> xfs_metadump cannot obfuscate metadata in the filesystem log.  Log
>> recovery of an obfuscated metadump image may expose clear-text
>> metadata and/or cause filesystem corruption in the restored image.
>> It is recommended that the source filesystem be mounted and unmounted
>> first if possible, to produce a metadump with a clean log.
> 
> "It is recommended that the source filesystem first be mounted and
> unmounted, if possible, to ensure that the log is clean.  That way, all
> metadata can be obfuscated correctly and the metadump will capture a
> clean log."
> 
> ...because mounting and unmounting itself does not produce metadumps. :)

That was the "first" bit, but "That way" is a bit colloquial IMHO.
<full_pedant_mode>

How about:

"It is recommended that the source filesystem first be mounted and
unmounted, if possible, to ensure that the log is clean.  After that
operation, all metadata will be obfuscated correctly and xfs_metadump
will capture a clean log."

-Eric

 
>> If a metadump must be produced from a filesystem with a dirty log,
>> it is recommended that obfuscation be turned off with -o option, if
>> metadata such as filenames is not considered sensitive.  If obfuscation
>> is required on a metadump with a dirty log, please inform the recipient
>> of the metadump image about this situation.
> 
> Otherwise seems fine to me.
> 
> --D
> 
>> ---
>>
>> -Eric
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
