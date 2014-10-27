Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id AD7747F5F
	for <xfs@oss.sgi.com>; Mon, 27 Oct 2014 10:56:47 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 8CD92304032
	for <xfs@oss.sgi.com>; Mon, 27 Oct 2014 08:56:47 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id aslIyT2IOKFLiuhB (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Mon, 27 Oct 2014 08:56:43 -0700 (PDT)
Received: from int-mx14.intmail.prod.int.phx2.redhat.com
	(int-mx14.intmail.prod.int.phx2.redhat.com [10.5.11.27])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id s9RFugSW005335
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256
	verify=FAIL) for <xfs@oss.sgi.com>; Mon, 27 Oct 2014 11:56:42 -0400
Message-ID: <544E6B39.9040309@redhat.com>
Date: Mon, 27 Oct 2014 10:56:41 -0500
From: Eric Sandeen <sandeen@redhat.com>
MIME-Version: 1.0
Subject: Re: [PATCH] xfs_io: add sync and syncfs commands
References: <544A9511.70500@redhat.com>
	<20141027114327.GD39598@bfoster.bfoster>
In-Reply-To: <20141027114327.GD39598@bfoster.bfoster>
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
Cc: xfs-oss <xfs@oss.sgi.com>

On 10/27/14 6:43 AM, Brian Foster wrote:
> On Fri, Oct 24, 2014 at 01:06:09PM -0500, Eric Sandeen wrote:

...

>> +void
>> +sync_init(void)
>> +{
>> +	sync_cmd.name = "sync";
>> +	sync_cmd.cfunc = sync_f;
>> +	sync_cmd.flags = CMD_NOMAP_OK | CMD_FOREIGN_OK;
> 
> Not a big deal given that we have sync(1), but CMD_NOFILE_OK..?
> 
> The rest looks good to me.
> 
> Brian

Ah, good eye, thanks.  Will send V2.

-Eric

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
