Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from smtp1.onthe.net.au ([203.22.196.249]:47986 "EHLO
        smtp1.onthe.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752370AbeC0WdR (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 27 Mar 2018 18:33:17 -0400
Date: Wed, 28 Mar 2018 09:33:10 +1100
From: Chris Dunlop <chris@onthe.net.au>
Subject: Re: file corruptions, 2nd half of 512b block
Message-ID: <20180327223310.GA4461@onthe.net.au>
References: <20180322150226.GA31029@onthe.net.au>
 <20180322180327.GI16617@bfoster.bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20180322180327.GI16617@bfoster.bfoster>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Brian Foster <bfoster@redhat.com>
Cc: linux-xfs@vger.kernel.org

On Thu, Mar 22, 2018 at 02:03:28PM -0400, Brian Foster wrote:
> On Fri, Mar 23, 2018 at 02:02:26AM +1100, Chris Dunlop wrote:
>> Hi,
>>
>> I'm experiencing 256-byte corruptions in files on XFS on 4.9.76.
>>
>> System configuration details below.
>>
>> For those cases where the corrupt file can be regenerated from other
>> data and the new file compared to the corrupt file (15 files in all),
>> the corruptions are invariably in the 2nd 256b half of a 512b sector,
>> part way through the file. That's pretty odd! Perhaps some kind of
>> buffer tail problem?
>>
>> Are there any known issues that might cause this?
>
> Nothing that I can think of. A quick look through the writeback changes
> shows this[1] commit, but I'd expect any corruption in that case to
> manifest as page size (4k) rather than at 256b granularity.
>
> [1] 40214d128e ("xfs: trim writepage mapping to within eof")

Looks like that issue can occur if the file is closed, then reopened and 
appended to. That's possible with the files written via ftp (the ftp 
upload allows for continuation of partial files), but not the files 
written via NFS - if they're incomplete they're removed and started from 
scratch.

> So you obviously have a fairly large/complex storage configuration. I
> think you have to assume that this corruption could be introduced pretty
> much anywhere in the stack (network, mm, fs, block layer, md) until it
> can be narrowed down.

Yup.

Per below I'm seeing a good checksum a bit after arrival and bad 
checksum some time later, so looks like it's not network.

>> 2018-03-04 21:40:44 data + md5 files written
>> 2018-03-04 22:43:33 checksum mismatch detected
>
> Seems like the corruption is detected fairly soon after creation. How
> often are these files explicitly checked/read? I also assume the files
> aren't ever modified..?

Correct, the files aren't ever (deliberately) modified.

The files are generally checked once, some time (minutes to hours) after 
landing. After the first check I've been (perhaps foolishly) relying on 
raid6 scrubs to keep the data intact.

The files may be read a few times more over the course of a month, then 
they're either removed or just sit there quietly for months to years. 

> FWIW, the patterns that you have shown so far do seem to suggest
> something higher level than a physical storage problem. Otherwise, I'd
> expect these instances wouldn't always necessarily land in file data.
> Have you run 'xfs_repair -n' on the fs to confirm there aren't any other
> problems?

I haven't tried xfs_repair yet. At 181T used and high but unknown at 
this point number of dirs and files, I imagine it will take quite a 
while and the filesystem shouldn't really be unavailable for more than 
low numbers of hours. I can use an LVM snapshot to do the 'xfs_repair 
-n', but I need to add enough spare capacity to hold the amount of data 
that arrives (at 0.5-1TB/day) during life of the check / snapshot. That 
might take a bit of fiddling because the system is getting short on 
drive bays.

Is it possible to work out approximately how long the check might take?

> OTOH, a 256b corruption seems quite unusual for a filesystem with 4k
> blocks. I suppose that could suggest some kind of memory/cache
> corruption as opposed to a bad page/extent state or something of that
> nature.

I should have mentioned in the system summary: it's ECC RAM, with no 
EDAC errors coming up. So it shouldn't be memory corruption due to a bad 
stick or whatever. But, yes, there can be other causes.

> Hmm, I guess the only productive thing I can think of right now is to
> see if you can try and detect the problem as soon as possible. For e.g.,
> it sounds like this is a closed system. If so, could you follow up every
> file creation with an immediate md5 verification (perhaps followed by an
> fadvise(DONTNEED) and another md5 check to try and catch an inconsistent
> pagecache)? Perhaps others might have further ideas..

The check runs "soon" after file arrival (usually minutes), but not 
immediately. I could potentially alter the ftp receiver to calculate the 
md5 as the file data is received and cross check with the md5 file at 
the end, but doing same with the files that arrive via NFS would be 
difficult.

The great majority of the corruptions have been in the files arriving 
via NFS - possibly because those files tend to be much larger so random 
corruptions simply hit them more, but also I guess possibly because NFS 
is more susceptible to whatever is causing the problem.

I have a number of instances where it definitely looks like the file has 
made it to the filesystem (but not necessarily disk) and checked ok, 
only to later fail the md5 check, e.g.:

2018-03-12 07:36:56 created
2018-03-12 07:50:05 check ok
2018-03-26 19:02:14 check bad

2018-03-13 08:13:10 created
2018-03-13 08:36:56 check ok
2018-03-26 14:58:39 check bad

2018-03-13 21:06:34 created
2018-03-13 21:11:18 check ok
2018-03-26 19:24:24 check bad

I've now (subsequent to those instances above) updated to your 
suggestion: do the check first (without DONTNEED), then if the file had 
pages in the vm before the first check (seen using 'vmtouch' Resident 
Pages), use DONTNEED (via 'vmtouch -e') and do the check again.

I haven't yet seen any corrupt files with this new scheme (it's now been 
in place for only 24 hours).

I've not played with vmtouch before so I'm not sure what's normal, but 
there seems to be some odd behaviour. Most of the time, 'vmtouch -e' 
clears the file from buffers immediately, but sometimes it leaves a 
single page resident, even in the face of repeated calls. I understand 
that fadvise(DONTNEED) is advisory (and of course there's always a 
chance something else can bring file pages back into vm), so I had it in 
a loop:

check_pages_buffered
checksum
if pages_were_buffered
  fadvise(DONTNEED)
  whilst pages_buffered
    fadvise(DONTNEED)
    sleep 2
  done
  checksum
fi

I had a case where that loop was running for 2.5 hours before self 
terminating, in the absence of anything else touching the file (that I 
could find), and another case where it continued for 1.5 hours before I 
killed it. It seems a single page can persist in memory (I don't know if 
it's the same page) for *hours* even with many, many fadvise(DONTNEED) 
calls. In testing, I was finally able to clear that file from vm using:

  echo 3 > /proc/sys/vm/drop_caches

...but that's a wee bit heavy to use to clear single pages so I'm now 
breaking the loop if pages_buffered <= 1.

Any idea what that impressively persistent page is about?

>> "cmp -l badfile goodfile" shows there are 256 bytes differing, in the
>> 2nd half of (512b) block 53906431.
>
> FWIW, that's the last (512b) sector of the associated (4k) page. Does
> that happen to be consistent across whatever other instances you have a
> record of?

Huh, I should have noticed that! Yes, all corruptions are the last 256b 
of a 4k page. And in fact all are the last 256b in the first 4k page of 
an 8k block. That's odd as well!

FYI, these are the 256b offsets now I'm now working with (there have 
been a few more since I started):

310799
876559
1400335
1676815
3516271
4243471
4919311
6267919
10212879
11520527
11842175
16179215
18018367
22609935
45314111
51365903
60588047
69212175
82352143
107812863
165136351
227067839
527947775

Thanks for your time!

Chris
