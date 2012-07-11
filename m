Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q6B2QGDb157204 for <xfs@oss.sgi.com>; Tue, 10 Jul 2012 21:26:16 -0500
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	7uRUbwToQDXI6cEr for <xfs@oss.sgi.com>;
	Tue, 10 Jul 2012 19:26:14 -0700 (PDT)
Date: Wed, 11 Jul 2012 12:26:09 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH V4] xfs: cleanup the mount options
Message-ID: <20120711022609.GX19223@dastard>
References: <20120706030532.GU19223@dastard>
	<1341747397-10649-1-git-send-email-gaowanlong@cn.fujitsu.com>
	<20120709002218.GW19223@dastard> <4FFAA2B4.6090503@cn.fujitsu.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <4FFAA2B4.6090503@cn.fujitsu.com>
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
To: Wanlong Gao <gaowanlong@cn.fujitsu.com>
Cc: Christoph Hellwig <hch@infradead.org>, Ben Myers <bpm@sgi.com>, Zach Brown <zab@zabbo.net>, XFS <xfs@oss.sgi.com>

On Mon, Jul 09, 2012 at 05:21:56PM +0800, Wanlong Gao wrote:
> On 07/09/2012 08:22 AM, Dave Chinner wrote:
> > On Sun, Jul 08, 2012 at 07:36:37PM +0800, Wanlong Gao wrote:
> >> remove the mount options macro, use tokens instead.
> >>
> >> CC: Ben Myers <bpm@sgi.com>
> >> CC: Christoph Hellwig <hch@infradead.org>
> >> CC: Dave Chinner <david@fromorbit.com>
> >> CC: Zach Brown <zab@zabbo.net>
> >> Signed-off-by: Wanlong Gao <gaowanlong@cn.fujitsu.com>
> >> ---
> > 
> > A "what's changed in this version" list would be handy here.
> > 
> >>  fs/xfs/xfs_super.c |  539 +++++++++++++++++++++++++++++++---------------------
> >>  1 file changed, 320 insertions(+), 219 deletions(-)
> > 
> > ....
> > 
> >> -
> >> -STATIC unsigned long
> >> -suffix_strtoul(char *s, char **endp, unsigned int base)
> >> +STATIC int
> >> +suffix_match_int(substring_t *s, int *result)
> > 
> > I'm not sure ints are the best unit to use here....
> > 
> >>  {
> >> -	int	last, shift_left_factor = 0;
> >> -	char	*value = s;
> >> +	int ret;
> >> +	int last, shift_left_factor = 0;
> >> +	char *value = s->to - 1;
> >>  
> >> -	last = strlen(value) - 1;
> >> -	if (value[last] == 'K' || value[last] == 'k') {
> >> +	if (*value == 'K' || *value == 'k') {
> >>  		shift_left_factor = 10;
> >> -		value[last] = '\0';
> >> +		s->to--;
> >>  	}
> >> -	if (value[last] == 'M' || value[last] == 'm') {
> >> +	if (*value == 'M' || *value == 'm') {
> >>  		shift_left_factor = 20;
> >> -		value[last] = '\0';
> >> +		s->to--;
> >>  	}
> >> -	if (value[last] == 'G' || value[last] == 'g') {
> >> +	if (*value == 'G' || *value == 'g') {
> >>  		shift_left_factor = 30;
> >> -		value[last] = '\0';
> >> +		s->to--;
> >>  	}
> >>  
> >> -	return simple_strtoul((const char *)s, endp, base) << shift_left_factor;
> >> +	ret = match_number(s, result, 0);
> >> +	*result = *result << shift_left_factor;
> > 
> > Because this overflows or gives the negative values for numbers like
> > 2G far too easily. I think this function needs to return an unsigned
> > long.
> 
> Do you mean the "result" should be "unsigned long" but not the return value?
> Because the return value is a error state.

result.

BTW: *result <<= shift_left_factor;

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
