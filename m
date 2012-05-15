Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q4F4llgk153298 for <xfs@oss.sgi.com>; Mon, 14 May 2012 23:47:47 -0500
Message-ID: <4FB1DFD1.709@oracle.com>
Date: Tue, 15 May 2012 12:47:13 +0800
From: Jeff Liu <jeff.liu@oracle.com>
MIME-Version: 1.0
Subject: Re: [PATCH v2 2/2] xfstests: introduce 280 for SEEK_DATA/SEEK_HOLE
	copy check
References: <4F2FE410.2040508@oracle.com> <4FAD2D18.20403@sgi.com>
In-Reply-To: <4FAD2D18.20403@sgi.com>
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
To: Rich Johnston <rjohnston@sgi.com>
Cc: xfs@oss.sgi.com

Hi Rich,

Sorry for my late response!

On 05/11/2012 11:15 PM, Rich Johnston wrote:

> 
> On 02/06/2012 08:30 AM, Jeff Liu wrote:
>> Introduce 280 for SEEK_DATA/SEEK_HOLE copy check.
>>
>> Signed-off-by: Jie Liu<jeff.liu@oracle.com>
>>
> 
> 
> 
>> +static int
>> +do_extent_copy(int src_fd, int dest_fd, off_t data_off, off_t hole_off)
>> +{
> 
> ...
> 
>> +
>> +    while (len>  0) {
>> +        memset(buf, 0, sizeof(buf));
>> +        ssize_t nr_read = read(src_fd, buf, BUF_SIZE);
> #RCJ The memset above is unnecessary.
> 
> 
>> +static int
>> +copy_extents(int src_fd, int dest_fd, off_t src_total_size)
>> +{
>> +    int ret = 0;
>> +    unsigned int i = 0;
> 
> ...
> 
>> +        ++i;
>> +        seek_start = hole_pos;
>> +    } while (seek_start<  src_total_size);
> #RCJ i is unused.

Thanks for the review, I'll fix them later.

-Jeff

> 
> Other than the comments above, this version of the test looks good.
> Reviewed-by: Rich Johnston<rjohnston@sgi.com>
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
