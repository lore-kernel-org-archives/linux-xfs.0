Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q256fUxS121503 for <xfs@oss.sgi.com>; Mon, 5 Mar 2012 00:41:30 -0600
Received: from server52.dayanadns.com (server52.dayanadns.com [204.50.22.15])
	by cuda.sgi.com with ESMTP id lueGFzS3pLWPCoGG (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Sun, 04 Mar 2012 22:41:29 -0800 (PST)
Received: from [64.254.187.212] (port=35133 helo=[10.0.0.7])
	by server52.dayanadns.com with esmtpsa (TLSv1:AES256-SHA:256)
	(Exim 4.67) (envelope-from <jeffrey.hundstad@mnsu.edu>)
	id 1S4Rbp-0003KD-VA
	for xfs@oss.sgi.com; Sun, 04 Mar 2012 22:41:27 -0800
Message-ID: <4F546014.3030601@mnsu.edu>
Date: Mon, 05 Mar 2012 00:41:24 -0600
From: Jeffrey Hundstad <jeffrey.hundstad@mnsu.edu>
MIME-Version: 1.0
Subject: Re: Poor performance using discard
References: <1330469778.9688.7.camel@core24> <20120229012259.GW3592@dastard>
	<1330480826.9688.23.camel@core24> <20120229040819.GZ3592@dastard>
	<1330702910.6438.40.camel@core24> <20120305030254.GA3592@dastard>
In-Reply-To: <20120305030254.GA3592@dastard>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

On 03/04/2012 09:02 PM, Dave Chinner wrote:
> On Fri, Mar 02, 2012 at 10:41:50AM -0500, Thomas Lynema wrote:
>> Peter was right then.  Per multiple recommendations
>> I'm switching to fstrim, it is quicker than the deletes.
>>
>> fstrim consistently takes about a minute to run on a 40GB
>> volume.
>>
>> time fstrim -v /usr
>> /usr: 9047117824 bytes were trimmed
>>
>> real	0m56.121s
>> user	0m0.090s
>> sys	0m0.000s
>>
>> I see that the running of fstrim was already discussed
>> http://oss.sgi.com/archives/xfs/2011-05/msg00338.html.
>>
>> Please add something to the FAQ about using SSDs.  It would be great if
>> people could see the recommended mount options and fstrim crontab entry
>> (or other option) for running xfs on a SSD.
> It's a publicly modifiable wiki. Feel free to add what you've
> learned here to a new FAQ entry - others will come by and correct
> anything in it that is inaccurate....

And it is already there:
http://xfs.org/index.php/FITRIM/discard

Feel free to expand it.

-- 
Jeffrey Hundstad

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
