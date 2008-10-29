Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 29 Oct 2008 06:32:51 -0700 (PDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m9TDWYvL016496
	for <xfs@oss.sgi.com>; Wed, 29 Oct 2008 06:32:34 -0700
Received: from qw-out-1920.google.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 7F546891158
	for <xfs@oss.sgi.com>; Wed, 29 Oct 2008 06:32:33 -0700 (PDT)
Received: from qw-out-1920.google.com (qw-out-1920.google.com [74.125.92.150]) by cuda.sgi.com with ESMTP id yFDmT1JTDfqZDgNn for <xfs@oss.sgi.com>; Wed, 29 Oct 2008 06:32:33 -0700 (PDT)
Received: by qw-out-1920.google.com with SMTP id 5so1432070qwc.32
        for <xfs@oss.sgi.com>; Wed, 29 Oct 2008 06:32:33 -0700 (PDT)
Message-ID: <490865E3.8070102@gmail.com>
Date: Wed, 29 Oct 2008 09:32:19 -0400
From: Ric Wheeler <ricwheeler@gmail.com>
MIME-Version: 1.0
Subject: Re: [patch 0/9] writeback data integrity and other fixes (take 3)
References: <20081028144715.683011000@suse.de> <20081028153953.GB3082@wotan.suse.de> <20081028222746.GB4985@disturbed> <20081029001653.GF15599@wotan.suse.de> <20081029031645.GE4985@disturbed> <20081029091203.GA32545@infradead.org> <20081029092143.GA5953@wotan.suse.de> <20081029094417.GA21824@infradead.org> <20081029103029.GC5953@wotan.suse.de> <20081029122234.GE846@shareable.org>
In-Reply-To: <20081029122234.GE846@shareable.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Jamie Lokier <jamie@shareable.org>
Cc: Nick Piggin <npiggin@suse.de>, Christoph Hellwig <hch@infradead.org>, linux-nfs@vger.kernel.org, akpm@linux-foundation.org, xfs@oss.sgi.com, linux-fsdevel@vger.kernel.org, Chris Mason <chris.mason@oracle.com>

Jamie Lokier wrote:
> Nick Piggin wrote:
>   
>> On Wed, Oct 29, 2008 at 05:44:17AM -0400, Christoph Hellwig wrote:
>>     
>>> On Wed, Oct 29, 2008 at 10:21:43AM +0100, Nick Piggin wrote:
>>>       
>>>> Please do.
>>>>         
>>> Well, there's one stumling block I haven't made progress on yet:
>>>
>>> I've changed the prototype of ->fsync to lose the dentry as we should
>>> always have a valid file struct.  Except that nfsd doesn't on
>>> directories.  So I either need to fake up a file there, or bail out
>>> and add a ->dir_sync export operation that needs just a dentry.
>>>       
>> OK. I don't know much about hthat code, but I would think nfsd
>> should look as close to the syscall layer as possible. I guess
>> there must be something prohibitive (some protocol semantics?).
>>
>> Is there anything that particularly makes it a file operation
>> as opposed to an inode operation?
>>     
>
> In principle, is fsync() required to flush all dirty data written
> through any file descriptor ever, or just dirty data written through
> the file descriptor used for fsync()?
>
> -- Jamie
> --
>   

Is a pointer to what seems to be the official posix spec for this - it 
is definitely per file descriptor, not per file system, etc...

What can happen by side effect (depending on the implementation) is that 
you can actually force out all data for any file. I found that you can 
approach non-fsync speeds for an fsync per file workload by simply 
writing all of the files out, then going back and fsync'ing them one at 
a time (last file first makes a bit of a difference). With that 
technique, you do get the hard promise of full data integrity and high 
speed. This is useful when you want to do bulk writes (tar, etc)

ric
