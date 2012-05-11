Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q4B2WKYO125833 for <xfs@oss.sgi.com>; Thu, 10 May 2012 21:32:21 -0500
Message-ID: <4FAC7A22.1090005@oracle.com>
Date: Fri, 11 May 2012 10:32:02 +0800
From: Jeff Liu <jeff.liu@oracle.com>
MIME-Version: 1.0
Subject: Re: [PATCH v3 1/2] xfstests: introduce 279 for SEEK_DATA/SEEK_HOLE
	sanity test
References: <4F410ABF.7070001@oracle.com> <20120510202810.GQ16881@sgi.com>
In-Reply-To: <20120510202810.GQ16881@sgi.com>
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
To: Ben Myers <bpm@sgi.com>
Cc: Christoph Hellwig <hch@infradead.org>, xfs@oss.sgi.com

On 05/11/2012 04:28 AM, Ben Myers wrote:

> On Sun, Feb 19, 2012 at 10:44:15PM +0800, Jeff Liu wrote:
>> Introduce 279 for SEEK_DATA/SEEK_HOLE sanity tests.
>>
>> Changes to v3:
>> --------------
>> * Redirect seek sanity test run log to 279.full.
>>
>> Signed-off-by: Jie Liu <jeff.liu@oracle.com>
> 
> ...
> 
>> diff --git a/src/seek_sanity_test.c b/src/seek_sanity_test.c
>> new file mode 100644
>> index 0000000..8f36dee
>> --- /dev/null
>> +++ b/src/seek_sanity_test.c
>> @@ -0,0 +1,683 @@
> 
> ...
> 
>> +static void get_file_system(int fd)
>> +{
>> +	struct statfs buf;
>> +
>> +	if (!fstatfs(fd, &buf))
>> +		fprintf(stdout, "File system magic#: 0x%x\n", buf.f_type);
> 
> Hrm...
> 
> # make
> Building include
> Building lib
> Building ltp
> Building src
> [DEP]
> [CC]    seek_sanity_test
> seek_sanity_test.c: In function 'get_file_system':
> seek_sanity_test.c:46: warning: format '%x' expects type 'unsigned int', but argument 3 has type 'long int'
> Building aio-dio-regress
> Building m4
> 
> I'll fix that up for you.

Thanks a lot!

-Jeff

> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
