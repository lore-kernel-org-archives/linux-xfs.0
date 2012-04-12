Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q3CDGmRR165823 for <xfs@oss.sgi.com>; Thu, 12 Apr 2012 08:16:48 -0500
Received: from acsinet15.oracle.com (acsinet15.oracle.com [141.146.126.227])
	by cuda.sgi.com with ESMTP id 2xSkP8PV25c3Vool (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Thu, 12 Apr 2012 06:16:47 -0700 (PDT)
Message-ID: <4F86D546.80804@oracle.com>
Date: Thu, 12 Apr 2012 21:14:46 +0800
From: Jeff Liu <jeff.liu@oracle.com>
MIME-Version: 1.0
Subject: Re: [PATCH] xfstests: Introduce test case 285 for project quota
	negative test collections
References: <4F7C575A.7030507@oracle.com>
	<20120411200227.GB28816@infradead.org>
In-Reply-To: <20120411200227.GB28816@infradead.org>
Reply-To: jeff.liu@oracle.com
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Christoph Hellwig <hch@infradead.org>
Cc: xfs@oss.sgi.com

Hi Christoph,

Thanks for your comments below, I'll fix them up and repost it here.

-Jeff
On 04/12/2012 04:02 AM, Christoph Hellwig wrote:

> Hi Jeff,
> 
> thanks a lot for sending this patch!
> 
>> I'd like to introduce a new test to verify something like this, it is intended to run as a negative test
>> collections for project quota.  It only verify the above issue for now, maybe its better to wrap the steps in a individual function?
> 
> We should have one testcase for one thing to test - by that defintion
> this bug should really stay a test case on it's own.  Some more comments
> below.
> 
>> +_create_pquota_config_files()
>> +{
>> +	echo "1:$tmpdir" > /etc/projects
>> +	echo "$project_name:1" > /etc/projid
>> +}
> 
> We can use numeric ids for projects directly, and the -p object to
> various xfs_quota subcommands also allows refering to a path instead
> of a project name, that way we don't have to rewrite the config files
> in /etc.
> 
>> +echo "*** create loopback image file ***"
>> +dd if=/dev/zero of=$tmpfile bs=4k count=4096 >/dev/null 2>&1
>> +
>> +echo "*** mkfs.xfs ***"
>> +mkfs.xfs -b size=4096 $tmpfile >/dev/null 2>&1
>> +
>> +# mount loopback image but without pquota option
>> +mount -o loop $tmpfile $tmpdir || _fail "!!! failed to loopback mount"
> 
> This should use _scratch_mkfs _scratch_mount and so on instead of
> opencoding it.



_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
