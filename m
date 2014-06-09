Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id E10967F51
	for <xfs@oss.sgi.com>; Mon,  9 Jun 2014 09:01:33 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id B1C8C8F8039
	for <xfs@oss.sgi.com>; Mon,  9 Jun 2014 07:01:30 -0700 (PDT)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id VGjIN4tO28n6yiUh for <xfs@oss.sgi.com>;
	Mon, 09 Jun 2014 07:01:23 -0700 (PDT)
Message-ID: <5395BE32.3080204@sandeen.net>
Date: Mon, 09 Jun 2014 09:01:22 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: [PATCH 1/3] xfs_fsr: ensure the line we read from leftofffile
	is null terminated
References: <53922B49.1050005@redhat.com> <53922C8E.3050700@sandeen.net>
	<20140609130235.GA31319@bfoster.bfoster>
In-Reply-To: <20140609130235.GA31319@bfoster.bfoster>
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
To: Brian Foster <bfoster@redhat.com>
Cc: Eric Sandeen <sandeen@redhat.com>, xfs-oss <xfs@oss.sgi.com>

On 6/9/14, 8:02 AM, Brian Foster wrote:
> On Fri, Jun 06, 2014 at 04:03:10PM -0500, Eric Sandeen wrote:
>> Ensure that the string we read from leftofffile is NULL
>> terminated; the buffer gets passed to strchr(), so
>> it's important that we ensure it ends with NULL.
>>
>> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
>> ---
>>
>> diff --git a/fsr/xfs_fsr.c b/fsr/xfs_fsr.c
>> index 3818f02..94d235c 100644
>> --- a/fsr/xfs_fsr.c
>> +++ b/fsr/xfs_fsr.c
>> @@ -554,6 +554,8 @@ fsrallfs(char *mtab, int howlong, char *leftofffile)
>>  			fsrprintf(_("could not read %s, starting with %s\n"),
>>  				leftofffile, *fs->dev);
>>  		} else {
>> +			/* Ensure the buffer we read is null terminated */
>> +			buf[SMBUFSZ-1] = '\0';
> 
> Maybe just initialize the buffer..?

and then read no more than SMBUFSZ-1... I dunno, 6 one way, half a dozen
the other?

-Eric

> Brian
> 
>>  			for (fs = fsbase; fs < fsend; fs++) {
>>  				fsname = fs->dev;
>>  				if ((strncmp(buf,fsname,strlen(fsname)) == 0)
>>
>> _______________________________________________
>> xfs mailing list
>> xfs@oss.sgi.com
>> http://oss.sgi.com/mailman/listinfo/xfs
> 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
