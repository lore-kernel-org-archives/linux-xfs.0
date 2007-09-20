Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 20 Sep 2007 00:35:38 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id l8K7ZUuw014863
	for <xfs@oss.sgi.com>; Thu, 20 Sep 2007 00:35:33 -0700
Message-ID: <46F222BD.5000001@sgi.com>
Date: Thu, 20 Sep 2007 17:35:25 +1000
From: Timothy Shimmin <tes@sgi.com>
MIME-Version: 1.0
Subject: Re: [GIT PULL] XFS update for 2.6.23
References: <20070918112447.4315C58C4C09@chook.melbourne.sgi.com> <46F16149.8080503@sandeen.net>
In-Reply-To: <46F16149.8080503@sandeen.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Eric Sandeen <sandeen@sandeen.net>
Cc: xfs@oss.sgi.com

Hi Eric,

Thanks.
I'll add that commit along with the sparse one...
    commit f5076f1243d6007145c0a658fbe05ace6b90a33f
    Author: Christoph Hellwig <hch@infradead.org>
    Date:   Wed Sep 19 15:27:30 2007 +1000

     [XFS] fix valid but harmless sparse warning

--Tim

Eric Sandeen wrote:
> Tim Shimmin wrote:
>> Hi Linus,
>>
>> A couple of fixes for potential fs corruption.
>> And one fix to ensure that xfs_mru_cache is not
>> doing anything unless the cache has active objects.
> 
> cc: trimmed...
> 
> Seems like you should push the filestreams fix too?
> 
> http://oss.sgi.com/cgi-bin/gitweb.cgi?p=xfs/xfs-2.6.git;a=commitdiff;h=f4b26d9d73e38ff915720440b1c373fb239a4254
> 
> Thanks,
> 
> -Eric
> 
> p.s. just FWIW, here are the patches I'm currently carrying in F8:
> 
> linux-2.6-xfs-avoid-replaying-inode-buffer-init.patch	In for-linus
> linux-2.6-xfs-filesize-updates.patch			In for-linus
> linux-2.6-xfs-filestreams-on-demand-MRU-reaping.patch	In for-linus
> linux-2.6-xfs-fix-filestreams-free-func-cast.patch
> linux-2.6-xfs-optimize-away-dmapi-tests.patch
> linux-2.6-xfs-optimize-away-realtime-tests.patch
> linux-2.6-xfs-refactor-xfs_mountfs.patch
> linux-2.6-xfs-setfattr-32bit-compat.patch
