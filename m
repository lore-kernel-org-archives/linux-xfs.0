Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q2BDrbSx125811 for <xfs@oss.sgi.com>; Sun, 11 Mar 2012 08:53:37 -0500
Received: from rcsinet15.oracle.com (rcsinet15.oracle.com [148.87.113.117]) by
	cuda.sgi.com with ESMTP id UfwnBPIExDBICcp1 (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Sun, 11 Mar 2012 06:53:35 -0700 (PDT)
Message-ID: <4F5C83F9.7090201@oracle.com>
Date: Sun, 11 Mar 2012 18:52:41 +0800
From: Jeff Liu <jeff.liu@oracle.com>
MIME-Version: 1.0
Subject: Re: [RFC PATCH v1 1/4] cgroup quota: add disk space parse strategy
	to res_counter
References: <4F59E799.6030409@oracle.com> <4F5C8A3A.7080601@parallels.com>
In-Reply-To: <4F5C8A3A.7080601@parallels.com>
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
To: Glauber Costa <glommer@parallels.com>
Cc: jack@suse.cz, Daniel Lezcano <daniel.lezcano@free.fr>, Christopher Jones <christopher.jones@oracle.com>, Li Zefan <lizf@cn.fujitsu.com>, xfs@oss.sgi.com, Christoph Hellwig <hch@infradead.org>, tj@kernel.org, Ben Myers <bpm@sgi.com>, tytso@MIT.EDU, lxc-devel@lists.sourceforge.net, "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>, cgroups@vger.kernel.org, Chris Mason <chris.mason@oracle.com>

On 03/11/2012 07:19 PM, Glauber Costa wrote:

> On 03/09/2012 03:20 PM, Jeff Liu wrote:
>> Introduce a new disk space parse strategy routine for cgroup quota
>> supports.
>> disk_space_parse() is simply copied from mmparse() with Petabytes and
>> Terabytes parse.
>>
>> Signed-off-by: Jie Liu<jeff.liu@oracle.com>
>> ---
>>   include/linux/res_counter.h |    3 ++
>>   kernel/res_counter.c        |   58
>> +++++++++++++++++++++++++++++++++++++++++++
>>   2 files changed, 61 insertions(+), 0 deletions(-)
>>
>> diff --git a/include/linux/res_counter.h b/include/linux/res_counter.h
>> index c9d625c..f8ce315 100644
>> --- a/include/linux/res_counter.h
>> +++ b/include/linux/res_counter.h
>> @@ -79,6 +79,9 @@ typedef int (*write_strategy_fn)(const char *buf,
>> unsigned long long *val);
>>   int res_counter_memparse_write_strategy(const char *buf,
>>                       unsigned long long *res);
>>
>> +int res_counter_diskspace_parse_write_strategy(const char *buf,
>> +                           unsigned long long *res);
>> +
>>   int res_counter_write(struct res_counter *counter, int member,
>>                 const char *buffer, write_strategy_fn write_strategy);
>>
>> diff --git a/kernel/res_counter.c b/kernel/res_counter.c
>> index 34683ef..42c1623 100644
>> --- a/kernel/res_counter.c
>> +++ b/kernel/res_counter.c
>> @@ -145,6 +145,64 @@ u64 res_counter_read_u64(struct res_counter
>> *counter, int member)
>>   }
>>   #endif
>>
>> +/*
>> + * Copy from memparse(), add terabytes, petabytes parse support.
>> + */
> Don't see a reason for that. It is all bytes and such, just add the
> modifiers you want to the normal parse...

ok, I'll take care.

Thanks,
-Jeff

> 
>> +unsigned long long disk_space_parse(const char *ptr, char **retptr)
>> +{
>> +    char *endptr; /* local pointer to end of parsed string */
>> +    unsigned long long ret = kstrtoull(ptr,&endptr, 0);
>> +
>> +    switch (*endptr) {
>> +    case 'P':
>> +    case 'p':
>> +        ret<<= 10;
>> +    case 'T':
>> +    case 't':
>> +        ret<<= 10;
>> +    case 'G':
>> +    case 'g':
>> +        ret<<= 10;
>> +    case 'M':
>> +    case 'm':
>> +        ret<<= 10;
>> +    case 'K':
>> +    case 'k':
>> +        ret<<= 10;
>> +        endptr++;
>> +    default:
>> +        break;
>> +    }
>> +
>> +    if (retptr)
>> +        *retptr = endptr;
>> +
>> +    return ret;
>> +}
>> +
>> +int res_counter_diskspace_parse_write_strategy(const char *buf,
>> +                           unsigned long long *res)
>> +{
>> +    char *end;
>> +
>> +    /* return RESOURCE_MAX(unlimited) if "-1" is specified */
>> +    if (*buf == '-') {
>> +        *res = kstrtoull(buf + 1,&end, 10);
>> +        if (*res != 1 || *end != '\0')
>> +            return -EINVAL;
>> +        *res = RESOURCE_MAX;
>> +        return 0;
>> +    }
>> +
>> +    /* FIXME - make memparse() take const char* args */
>> +    *res = disk_space_parse((char *)buf,&end);
>> +    if (*end != '\0')
>> +        return -EINVAL;
>> +
>> +    /* FIXME - need to return *res as block aligned? */
>> +    return 0;
>> +}
>> +
>>   int res_counter_memparse_write_strategy(const char *buf,
>>                       unsigned long long *res)
>>   {
> 


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
